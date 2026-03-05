# MathKids Adventure - Subscription System Design

> **เกมคณิตศาสตร์สำหรับเด็ก 3-6 ขวบ | Flutter + Google Play Billing**

---

## 📋 Table of Contents

1. [Business Model](#business-model)
2. [Technical Architecture](#technical-architecture)
3. [Subscription Tiers](#subscription-tiers)
4. [Feature Gating](#feature-gating)
5. [Parent Gate](#parent-gate)
6. [Implementation Guide](#implementation-guide)
7. [Compliance & Policy](#compliance--policy)
8. [Testing Strategy](#testing-strategy)

---

## 💰 Business Model

### Freemium Strategy

| Tier | Price | Features | Target |
|------|-------|----------|--------|
| **Free** | Free forever | • 5 เกม<br>• 3 ด่านแรกต่อเกม<br>• โฆษณา | ทดลองเล่น |
| **Premium** | ฿49/เดือน<br>(7 วันทดลองฟรี) | • 5 เกม<br>• **10 ด่านทั้งหมด**<br>• ไม่มีโฆษณา<br>• เนื้อหาเพิ่มในอนาคต | ผู้ปกครอง |

### Conversion Funnel

```
100 ดาวน์โหลด
    ↓
 50 ผู้เล่นจริง (Day 1)
    ↓
 15 เล่นครบ 3 ด่าน (Hit Paywall)
    ↓
  3 เริ่มทดลอง Free Trial (20% conversion)
    ↓
  2 Subscribe หลังทดลอง (67% retention)
```

**Target Metrics**:
- Day 1 Retention: 50%
- Free to Trial: 20%
- Trial to Paid: 67%
- Monthly Churn: <10%

---

## 🏗️ Technical Architecture

### System Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        App Startup                          │
│  1. Initialize InAppPurchase                                │
│  2. Listen to purchase stream                               │
│  3. Restore purchases (background)                          │
│  4. Update SubscriptionProvider                             │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                    Main Game Flow                           │
│                                                             │
│  ┌──────────────┐      ┌──────────────┐                    │
│  │  Free User   │      │ Premium User │                    │
│  │              │      │              │                    │
│  │ • Stage 1-3  │      │ • Stage 1-10 │                    │
│  │ • Ads        │      │ • No Ads     │                    │
│  └──────┬───────┘      └──────────────┘                    │
│         │                                                   │
│         │ (เล่นถึงด่าน 4)                                   │
│         ↓                                                   │
│  ┌──────────────┐                                          │
│  │ Locked Gate  │                                          │
│  └──────┬───────┘                                          │
│         │                                                   │
│         ↓                                                   │
│  ┌──────────────┐                                          │
│  │ Parent Gate  │ ← Math Question (7 + 3 = ?)             │
│  └──────┬───────┘                                          │
│         │ (ตอบถูก)                                          │
│         ↓                                                   │
│  ┌──────────────┐                                          │
│  │   Paywall    │ ← ฿49/เดือน, ทดลอง 7 วัน                │
│  └──────┬───────┘                                          │
│         │                                                   │
│         ↓                                                   │
│  ┌──────────────┐                                          │
│  │ Google Play  │                                          │
│  │   Billing    │                                          │
│  └──────┬───────┘                                          │
│         │ (สำเร็จ)                                          │
│         ↓                                                   │
│  ┌──────────────┐                                          │
│  │ Unlock All   │                                          │
│  │  Features    │                                          │
│  └──────────────┘                                          │
└─────────────────────────────────────────────────────────────┘
```

### File Structure

```
lib/
├── core/
│   └── constants/
│       └── subscription_constants.dart   # Product IDs, configs
├── data/
│   └── models/
│       └── subscription_status.dart      # Data models
├── services/
│   ├── subscription_service.dart         # Google Play Billing
│   └── progress_service.dart             # ปรับให้รองรับ Premium
├── providers/
│   └── subscription_provider.dart        # State management
├── ui/
│   ├── screens/
│   │   ├── parent_gate_screen.dart       # Parent verification
│   │   └── paywall_screen.dart           # Subscription UI
│   └── widgets/
│       ├── locked_stage_overlay.dart     # ด่านล็อค
│       └── premium_badge.dart            # Premium indicator
└── main.dart                             # Initialize subscription
```

---

## 🎯 Subscription Tiers

### Product Configuration

**Google Play Console Setup:**

| Field | Value |
|-------|-------|
| **Product ID** | `mathkids_premium_monthly` |
| **Type** | Auto-renewing subscription |
| **Base Plan ID** | `monthly-plan` |
| **Billing Period** | 1 month |
| **Price** | ฿49.00 THB |
| **Free Trial** | 7 days |
| **Grace Period** | 3 days |
| **Status** | Active |

### Subscription Status Model

```dart
enum SubscriptionTier {
  free,
  premium,
}

enum SubscriptionState {
  active,        // กำลังใช้งาน
  trial,         // ช่วงทดลอง
  expired,       // หมดอายุ
  canceled,      // ยกเลิกแล้ว (ยังใช้ได้ถึงสิ้นรอบบิล)
  gracePeriod,   // ช่วงผ่อนผัน (ชำระไม่สำเร็จ)
  paused,        // พักชั่วคราว
}

class SubscriptionStatus {
  final SubscriptionTier tier;
  final SubscriptionState state;
  final DateTime? expiryDate;
  final bool isActive;

  bool get isPremium => tier == SubscriptionTier.premium && isActive;
  bool get isTrial => state == SubscriptionState.trial;
  int get daysRemaining => expiryDate?.difference(DateTime.now()).inDays ?? 0;
}
```

---

## 🔒 Feature Gating

### Stage Lock Strategy

**Current System**: 10 ด่านต่อเกม

**Free Tier**:
- ✅ ด่าน 1-3: เล่นได้
- 🔒 ด่าน 4-10: ล็อค

**Premium Tier**:
- ✅ ด่าน 1-10: เล่นได้ทั้งหมด

### Implementation

```dart
// lib/services/progress_service.dart

class ProgressService {
  final SubscriptionProvider _subscriptionProvider;

  int getAccessibleStages(GameType gameType) {
    final totalStages = QuestionBank.getTotalLevels(gameType); // 10

    if (_subscriptionProvider.isPremium) {
      return totalStages; // 10 ด่าน
    } else {
      return 3; // Free: 3 ด่านแรก
    }
  }

  bool isStageUnlocked(GameType gameType, int stageNumber) {
    // ตรวจสอบว่าเคยผ่านด่านก่อนหน้าไหม
    final previousStageCompleted = /* check from SharedPreferences */;

    // ตรวจสอบว่าอยู่ในขอบเขตที่เข้าถึงได้ไหม
    final accessibleStages = getAccessibleStages(gameType);

    return stageNumber <= accessibleStages &&
           (stageNumber == 1 || previousStageCompleted);
  }
}
```

### UI Changes

**Stage Select Screen**:
```dart
// lib/screens/stage_select/stage_select_screen.dart

Widget _buildStageCard(StageProgress stage, bool isSmallScreen) {
  final isLocked = !_progressService.isStageUnlocked(
    widget.gameType,
    stage.stageNumber
  );

  final isPremiumLock = stage.stageNumber > 3 &&
                        !_subscriptionProvider.isPremium;

  return GestureDetector(
    onTap: isLocked
      ? (isPremiumLock ? _showPremiumGate : null)
      : () => _startStage(stage.stageNumber),
    child: Stack(
      children: [
        _buildStageContent(stage, isLocked),
        if (isPremiumLock) PremiumBadge(), // 👑 icon
      ],
    ),
  );
}

void _showPremiumGate() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ParentGateScreen()),
  );
}
```

---

## 👨‍👩‍👧 Parent Gate

### COPPA Compliance

**Requirement**: เด็กต้องไม่สามารถเข้าถึง Paywall ได้โดยตรง

### Design

**Math Question Verification**:
```
┌──────────────────────────────────────┐
│        🔐 Parent Verification         │
├──────────────────────────────────────┤
│                                      │
│  โปรดแก้โจทย์เพื่อดำเนินการต่อ:        │
│                                      │
│         7 + 3 = ?                    │
│                                      │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐        │
│  │ 9  │ │ 10 │ │ 11 │ │ 12 │        │
│  └────┘ └────┘ └────┘ └────┘        │
│                                      │
│  คำเตือน: หน้านี้สำหรับผู้ปกครอง      │
│           เท่านั้น                    │
└──────────────────────────────────────┘
```

### Implementation

```dart
// lib/ui/screens/parent_gate_screen.dart

class ParentGateScreen extends StatefulWidget {
  @override
  _ParentGateScreenState createState() => _ParentGateScreenState();
}

class _ParentGateScreenState extends State<ParentGateScreen> {
  late int _num1;
  late int _num2;
  late int _correctAnswer;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    final random = Random();
    _num1 = random.nextInt(10) + 1;  // 1-10
    _num2 = random.nextInt(10) + 1;  // 1-10
    _correctAnswer = _num1 + _num2;
  }

  void _checkAnswer(int answer) {
    if (answer == _correctAnswer) {
      // ✅ ตอบถูก → ไป Paywall
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PaywallScreen()),
      );
    } else {
      // ❌ ตอบผิด → สุ่มโจทย์ใหม่
      setState(() {
        _generateQuestion();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('คำตอบไม่ถูกต้อง กรุณาลองใหม่')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = _generateOptions();

    return Scaffold(
      appBar: AppBar(title: Text('ยืนยันผู้ปกครอง')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 64),
            SizedBox(height: 24),
            Text(
              'โปรดแก้โจทย์เพื่อดำเนินการต่อ',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 32),
            Text(
              '$_num1 + $_num2 = ?',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            Wrap(
              spacing: 16,
              children: options.map((option) {
                return ElevatedButton(
                  onPressed: () => _checkAnswer(option),
                  child: Text('$option', style: TextStyle(fontSize: 24)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(80, 80),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 48),
            Text(
              '⚠️ หน้านี้สำหรับผู้ปกครองเท่านั้น',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  List<int> _generateOptions() {
    final options = <int>{_correctAnswer};
    final random = Random();

    while (options.length < 4) {
      final wrong = _correctAnswer + random.nextInt(5) - 2; // ±2
      if (wrong > 0 && wrong <= 20) {
        options.add(wrong);
      }
    }

    return options.toList()..shuffle();
  }
}
```

---

## 💳 Paywall Screen

### Design Principles

1. **Clear Value Proposition**: บอกชัดว่าได้อะไร
2. **Transparent Pricing**: ราคา + ทดลองฟรี + ยกเลิกได้ตลอด
3. **Restore Purchase Button**: Required by Apple & Google
4. **Parent Language**: ไม่ใช้ภาษาเด็ก

### UI Design

```
┌──────────────────────────────────────┐
│         👑 Premium Version            │
├──────────────────────────────────────┤
│                                      │
│  ✅ ปลดล็อค 10 ด่านทั้งหมด           │
│  ✅ ไม่มีโฆษณา                        │
│  ✅ เนื้อหาเพิ่มในอนาคต               │
│                                      │
│  ┌────────────────────────────────┐  │
│  │   เริ่มทดลองฟรี 7 วัน           │  │
│  │   แล้ว ฿49/เดือน                │  │
│  │                                │  │
│  │   ยกเลิกได้ตลอดเวลา             │  │
│  └────────────────────────────────┘  │
│                                      │
│  [  คืนค่าการซื้อ  ]                │
│                                      │
│  • ต่ออายุอัตโนมัติทุกเดือน          │
│  • ยกเลิกได้ใน Google Play Store    │
│  • ข้อกำหนดการใช้งาน                 │
│  • นโยบายความเป็นส่วนตัว             │
└──────────────────────────────────────┘
```

### Implementation

```dart
// lib/ui/screens/paywall_screen.dart

class PaywallScreen extends StatelessWidget {
  final SubscriptionService _subscriptionService = SubscriptionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Premium Version')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(Icons.workspace_premium, size: 80, color: Colors.amber),
              SizedBox(height: 24),

              Text(
                'ปลดล็อคเนื้อหาทั้งหมด',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),

              _buildFeatureList(),
              SizedBox(height: 32),

              _buildPricingCard(context),
              SizedBox(height: 24),

              ElevatedButton(
                onPressed: () => _restorePurchases(context),
                child: Text('คืนค่าการซื้อ'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 56),
                ),
              ),
              SizedBox(height: 16),

              _buildLegalText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    return Column(
      children: [
        _buildFeature('ปลดล็อค 10 ด่านทั้งหมด (50 ด่าน)'),
        _buildFeature('ไม่มีโฆษณารบกวน'),
        _buildFeature('เนื้อหาเพิ่มในอนาคต'),
        _buildFeature('รองรับหลายอุปกรณ์'),
      ],
    );
  }

  Widget _buildFeature(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Column(
        children: [
          Text(
            'เริ่มทดลองฟรี 7 วัน',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'แล้ว ฿49/เดือน',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _subscribe(context),
            child: Text('สมัครสมาชิก', style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 56),
              backgroundColor: Colors.blue,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'ยกเลิกได้ตลอดเวลา',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalText() {
    return Column(
      children: [
        Text(
          '• ต่ออายุอัตโนมัติทุกเดือน',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          '• ยกเลิกได้ใน Google Play Store',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => _openUrl('https://example.com/terms'),
              child: Text('ข้อกำหนด'),
            ),
            Text('•'),
            TextButton(
              onPressed: () => _openUrl('https://example.com/privacy'),
              child: Text('นโยบาย'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _subscribe(BuildContext context) async {
    try {
      final success = await _subscriptionService.subscribe();

      if (success) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('สมัครสมาชิกสำเร็จ! 🎉')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

  Future<void> _restorePurchases(BuildContext context) async {
    try {
      final restored = await _subscriptionService.restorePurchases();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            restored
              ? 'คืนค่าการซื้อสำเร็จ! ✅'
              : 'ไม่พบประวัติการซื้อ',
          ),
        ),
      );

      if (restored) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

  void _openUrl(String url) {
    // Open URL in browser
  }
}
```

---

## 🛠️ Implementation Guide

### Step 1: Add Dependencies

```yaml
# pubspec.yaml
dependencies:
  in_app_purchase: ^3.2.0
  in_app_purchase_android: ^0.3.6+2
  in_app_purchase_storekit: ^0.3.17+2
  provider: ^6.1.2
```

### Step 2: Subscription Service

```dart
// lib/services/subscription_service.dart

import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

class SubscriptionService {
  static const String PRODUCT_ID = 'mathkids_premium_monthly';

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // Callback เมื่อสถานะเปลี่ยน
  Function(SubscriptionStatus)? onStatusChanged;

  /// Initialize subscription service
  Future<void> initialize() async {
    // เช็คว่า store พร้อมใช้งานไหม
    final bool available = await _iap.isAvailable();
    if (!available) {
      throw Exception('Store not available');
    }

    // ฟัง purchase updates
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdated,
      onDone: _onPurchaseDone,
      onError: _onPurchaseError,
    );

    // Restore purchases on startup
    await restorePurchases();
  }

  /// Subscribe to premium
  Future<bool> subscribe() async {
    try {
      // ดึงข้อมูล product
      final ProductDetailsResponse response = await _iap.queryProductDetails({PRODUCT_ID});

      if (response.notFoundIDs.isNotEmpty) {
        throw Exception('Product not found');
      }

      if (response.error != null) {
        throw Exception(response.error!.message);
      }

      final ProductDetails product = response.productDetails.first;

      // เริ่มการซื้อ
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );

      return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      print('❌ Subscribe error: $e');
      return false;
    }
  }

  /// Restore previous purchases
  Future<bool> restorePurchases() async {
    try {
      await _iap.restorePurchases();
      return true;
    } catch (e) {
      print('❌ Restore error: $e');
      return false;
    }
  }

  /// Check if user has active subscription
  Future<bool> isPremiumUser() async {
    try {
      // Query past purchases
      final QueryPurchaseDetailsResponse response =
        await _iap.queryPastPurchases();

      if (response.error != null) {
        return false;
      }

      // หา subscription ที่ active
      for (final purchase in response.pastPurchases) {
        if (purchase.productID == PRODUCT_ID) {
          if (await _verifyPurchase(purchase)) {
            return true;
          }
        }
      }

      return false;
    } catch (e) {
      print('❌ Check premium error: $e');
      return false;
    }
  }

  /// Handle purchase updates
  void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchase in purchaseDetailsList) {
      print('📦 Purchase update: ${purchase.status}');

      switch (purchase.status) {
        case PurchaseStatus.pending:
          _handlePending(purchase);
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _handlePurchased(purchase);
          break;
        case PurchaseStatus.error:
          _handleError(purchase);
          break;
        case PurchaseStatus.canceled:
          _handleCanceled(purchase);
          break;
      }

      // Complete purchase
      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
  }

  void _handlePending(PurchaseDetails purchase) {
    print('⏳ Purchase pending: ${purchase.productID}');
  }

  void _handlePurchased(PurchaseDetails purchase) async {
    print('✅ Purchase successful: ${purchase.productID}');

    // Verify purchase
    final bool valid = await _verifyPurchase(purchase);

    if (valid) {
      // Update subscription status
      onStatusChanged?.call(SubscriptionStatus(
        tier: SubscriptionTier.premium,
        state: SubscriptionState.active,
        isActive: true,
      ));
    }
  }

  void _handleError(PurchaseDetails purchase) {
    print('❌ Purchase error: ${purchase.error}');
  }

  void _handleCanceled(PurchaseDetails purchase) {
    print('🚫 Purchase canceled: ${purchase.productID}');
  }

  /// Verify purchase (basic client-side validation)
  /// TODO: Implement server-side validation for production
  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    // Basic validation
    if (purchase.productID != PRODUCT_ID) {
      return false;
    }

    // Android-specific validation
    if (Platform.isAndroid) {
      final GooglePlayPurchaseDetails androidPurchase =
        purchase as GooglePlayPurchaseDetails;

      // Check if acknowledged
      return androidPurchase.billingClientPurchase.isAcknowledged;
    }

    // iOS-specific validation
    if (Platform.isIOS) {
      final AppStorePurchaseDetails iosPurchase =
        purchase as AppStorePurchaseDetails;

      // Verify receipt
      return iosPurchase.verificationData.serverVerificationData.isNotEmpty;
    }

    return true;
  }

  void _onPurchaseDone() {
    print('✅ Purchase stream done');
  }

  void _onPurchaseError(dynamic error) {
    print('❌ Purchase stream error: $error');
  }

  /// Dispose
  void dispose() {
    _subscription?.cancel();
  }
}
```

### Step 3: Subscription Provider

```dart
// lib/providers/subscription_provider.dart

import 'package:flutter/foundation.dart';
import '../services/subscription_service.dart';
import '../data/models/subscription_status.dart';

class SubscriptionProvider with ChangeNotifier {
  final SubscriptionService _subscriptionService = SubscriptionService();

  SubscriptionStatus _status = SubscriptionStatus(
    tier: SubscriptionTier.free,
    state: SubscriptionState.expired,
    isActive: false,
  );

  bool _isLoading = false;

  SubscriptionStatus get status => _status;
  bool get isPremium => _status.isPremium;
  bool get isTrial => _status.isTrial;
  bool get isLoading => _isLoading;

  /// Initialize subscription service
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _subscriptionService.initialize();

      // Set callback
      _subscriptionService.onStatusChanged = _updateStatus;

      // Check current status
      final isPremium = await _subscriptionService.isPremiumUser();

      if (isPremium) {
        _updateStatus(SubscriptionStatus(
          tier: SubscriptionTier.premium,
          state: SubscriptionState.active,
          isActive: true,
        ));
      }
    } catch (e) {
      print('❌ Initialize subscription error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Subscribe to premium
  Future<bool> subscribe() async {
    _isLoading = true;
    notifyListeners();

    try {
      return await _subscriptionService.subscribe();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _subscriptionService.restorePurchases();

      if (success) {
        final isPremium = await _subscriptionService.isPremiumUser();
        if (isPremium) {
          _updateStatus(SubscriptionStatus(
            tier: SubscriptionTier.premium,
            state: SubscriptionState.active,
            isActive: true,
          ));
        }
      }

      return success;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _updateStatus(SubscriptionStatus status) {
    _status = status;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscriptionService.dispose();
    super.dispose();
  }
}
```

### Step 4: Main App Integration

```dart
// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/subscription_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        // ... other providers
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize subscription on app start
    Future.microtask(() {
      context.read<SubscriptionProvider>().initialize();
    });

    return MaterialApp(
      title: 'MathKids Adventure',
      home: HomeScreen(),
    );
  }
}
```

---

## 📜 Compliance & Policy

### COPPA Compliance Checklist

| Requirement | Implementation | Status |
|-------------|----------------|--------|
| **Parent Gate** | Math question before paywall | ✅ |
| **No Personal Data** | No login, no email, no name | ✅ |
| **Transparent Pricing** | Clear subscription terms | ✅ |
| **Restore Purchase** | Available in settings | ✅ |
| **Cancel Anytime** | Via Google Play Store | ✅ |
| **Privacy Policy** | Link in app & store | 📝 TODO |
| **Terms of Service** | Link in app & store | 📝 TODO |

### Google Play Family Policy

**Required Elements**:
- ✅ Age Rating: 3+
- ✅ No 3rd-party ads (or COPPA-compliant only)
- ✅ No data collection without consent
- ✅ Parent verification for purchases
- ✅ Clear subscription management

**Prohibited**:
- ❌ Misleading UI (e.g., "FREE!" เมื่อจริงๆมี subscription)
- ❌ Hidden costs
- ❌ Direct purchase by kids
- ❌ Social features without safety measures

---

## 🧪 Testing Strategy

### Test Accounts Setup

**Google Play Console**:
1. Go to **Setup → License testing**
2. Add test accounts: `your-email@gmail.com`
3. Enable test purchases

### Test Cases

#### 1. Purchase Flow
```
✅ ฟรี → กดด่าน 4 → Parent Gate (ตอบถูก) → Paywall → Subscribe
✅ ฟรี → กดด่าน 4 → Parent Gate (ตอบผิด) → กลับเมนู
✅ Paywall → กด "สมัครสมาชิก" → Google Play → สำเร็จ
✅ Paywall → กด "สมัครสมาชิก" → Google Play → ยกเลิก
```

#### 2. Restore Purchase
```
✅ Subscribe บนอุปกรณ์ A → Uninstall → Reinstall → Restore → Premium
✅ Subscribe บนอุปกรณ์ A → Install บนอุปกรณ์ B → Restore → Premium
```

#### 3. Subscription States
```
✅ Trial active → ด่าน 1-10 ปลดล็อค
✅ Trial expired → ด่าน 4-10 ล็อค
✅ Premium active → ด่าน 1-10 ปลดล็อค
✅ Premium expired → ด่าน 4-10 ล็อค
✅ Grace period → ยังใช้ได้ชั่วคราว
```

#### 4. Edge Cases
```
✅ No internet → แสดง error gracefully
✅ Google Play unavailable → ฟอลล์แบ็คเป็น Free
✅ Purchase pending → แสดงสถานะ "กำลังดำเนินการ"
✅ Refund → ถอนสิทธิ์ Premium ทันที
```

### Testing Commands

```bash
# Android real device testing
flutter run --release -d <device-id>

# Test with debug log
adb logcat | grep -i "purchase"

# Check subscription status
adb shell am start -a android.intent.action.VIEW \
  -d "https://play.google.com/store/account/subscriptions"
```

---

## 📊 Analytics & Metrics

### Track These Events

```dart
// Firebase Analytics or similar

// Paywall
analytics.logEvent('paywall_shown');
analytics.logEvent('paywall_subscribe_clicked');
analytics.logEvent('paywall_restore_clicked');

// Purchase
analytics.logEvent('purchase_started');
analytics.logEvent('purchase_success', parameters: {'product_id': PRODUCT_ID});
analytics.logEvent('purchase_failed', parameters: {'error': error});
analytics.logEvent('purchase_canceled');

// Trial
analytics.logEvent('trial_started');
analytics.logEvent('trial_converted');
analytics.logEvent('trial_expired');

// Feature Gating
analytics.logEvent('locked_stage_tapped', parameters: {'stage': stageNumber});
analytics.logEvent('parent_gate_shown');
analytics.logEvent('parent_gate_passed');
analytics.logEvent('parent_gate_failed');
```

### KPIs to Monitor

| Metric | Target | Formula |
|--------|--------|---------|
| Free to Trial Conversion | 20% | (Trials / Free Users) × 100 |
| Trial to Paid Conversion | 67% | (Paid / Trials) × 100 |
| Monthly Churn Rate | <10% | (Cancels / Active) × 100 |
| ARPU | ฿30+ | Revenue / Total Users |
| LTV | ฿300+ | ARPU × Average Months |

---

## 🚀 Launch Checklist

### Pre-Launch

- [ ] Subscription product created in Google Play Console
- [ ] Parent Gate implemented & tested
- [ ] Paywall design completed
- [ ] Restore purchase tested
- [ ] Privacy Policy & Terms uploaded
- [ ] Analytics events implemented
- [ ] Test accounts verified all flows
- [ ] Edge cases handled

### Launch

- [ ] Internal testing (1 week)
- [ ] Closed beta (2 weeks)
- [ ] Open beta (optional)
- [ ] Production release

### Post-Launch

- [ ] Monitor conversion funnel
- [ ] A/B test paywall designs
- [ ] Collect user feedback
- [ ] Iterate on pricing
- [ ] Add seasonal promotions

---

## 📚 References

### Official Documentation
- [Google Play Billing](https://developer.android.com/google/play/billing)
- [in_app_purchase Plugin](https://pub.dev/packages/in_app_purchase)
- [Flutter In-App Purchases Codelab](https://codelabs.developers.google.com/codelabs/flutter-in-app-purchases)
- [Google Play Families Policy](https://support.google.com/googleplay/android-developer/answer/9893335)

### COPPA & Kids Apps
- [COPPA Compliance Guide](https://www.andromo.com/blog/kid-app-coppa-gdpr/)
- [Designing Apps for Children](https://www.iubenda.com/blog/guide-coppa-mobile-apps/)
- [Kids App Policy Update](https://www.superawesome.com/blog/helping-kids-developers-comply-with-googles-play-store-policy-update/)

### Best Practices
- [Flutter In-App Purchases Best Practices](https://blog.logrocket.com/flutter-in-app-purchase-subscription-capability/)
- [Subscription Implementation Guide](https://www.linkfive.io/flutter-blog/subscriptions-in-flutter-the-complete-implementation-guide/)
- [Revenue Optimization Tips](https://medium.com/flutter-community/flutter-in-app-purchases-simplified-with-revenuecat-tips-and-sales-strategies-0e7f55f1aec7)

---

**สรุป**: ระบบ Subscription ที่ออกแบบนี้ครอบคลุมทั้ง technical implementation, compliance, และ business strategy พร้อมใช้งานจริงสำหรับเกมคณิตศาสตร์เด็กครับ! 🎉

**Next Steps**:
1. Review design นี้
2. ถามคำถามที่สงสัย
3. เริ่ม implement ทีละ step

# Pulsey 🩸

تطبيق Flutter لتسجيل قراءات السكر في الدم، عرضها كرسوم بيانية وسجل، وتذكير يومي بالقياس.

## التشغيل

```bash
flutter pub get
flutter run
flutter analyze   # فحص الكود
flutter test      # تشغيل الاختبارات
```

## المعمارية: Feature-First

الكود مقسّم حسب **الميزة** (feature) وليس حسب نوع الملف. كل ميزة مجلد مستقل
فيه كل ما يخصها، وداخلها ثلاث طبقات:

```
lib/
├── main.dart              ← نقطة البداية: تحميل التخزين والإشعارات ثم تشغيل التطبيق
├── app/
│   └── app.dart           ← MaterialApp + قرار أول شاشة (Dashboard / Setup / Splash)
├── core/                  ← أشياء مشتركة لا تخص ميزة واحدة
│   ├── notifications/     ← NotificationService (غلاف حول flutter_local_notifications)
│   ├── storage/           ← sharedPreferencesProvider
│   ├── theme/             ← الألوان وأنماط النصوص
│   └── utils/             ← تنسيق التاريخ
└── features/
    ├── onboarding/        ← شاشة البداية، صفحات التعريف، شاشة الترحيب
    ├── auth/              ← شاشة التسجيل (واجهة فقط حالياً، بدون خادم)
    ├── profile/           ← بيانات المستخدم + خطوات الإعداد الست
    ├── readings/          ← القراءات: الإضافة، الإحصائيات، الرسوم، السجل
    └── settings/          ← الحدود المستهدفة، الوحدات، وقت التذكير
```

### الطبقات داخل كل ميزة

| الطبقة | ماذا تحتوي | تعتمد على |
|---|---|---|
| `domain/` | الموديلات والمنطق الصافي (Dart فقط، بدون Flutter UI) مثل `SugarReading`، `ReadingStats`، `GlucoseLevel` | لا شيء |
| `data/` | الـ Repositories: الكود الوحيد الذي يعرف **كيف** تُحفظ البيانات | `domain` |
| `presentation/` | `providers/` (Riverpod Notifiers) + `screens/` + `widgets/` | `domain` و `data` |

**القاعدة الذهبية:** الشاشات لا تلمس `SharedPreferences` مباشرة أبداً.
الشاشة ← Controller (Riverpod) ← Repository ← التخزين.

### مسار البيانات (مثال: إضافة قراءة)

```
AddReadingDialog
   │  ref.read(readingsProvider.notifier).add(reading)
   ▼
ReadingsController (AsyncNotifier)
   │  1) يحدّث الحالة فوراً  2) يحفظ عبر الـ repository  3) يتراجع لو فشل الحفظ
   ▼
ReadingsRepository (interface)  ◄── LocalReadingsRepository (SharedPreferences)
```

`ReadingsRepository` واجهة (interface)، فلو أضفنا خادماً لاحقاً نكتب
`RemoteReadingsRepository` ونغيّر سطراً واحداً في `readingsRepositoryProvider`
بدون أي تعديل على الشاشات.

### إدارة الحالة (Riverpod)

| Provider | النوع | الوظيفة |
|---|---|---|
| `profileProvider` | `Notifier<UserProfile?>` | الملف الشخصي المحفوظ (null قبل إنهاء الإعداد) |
| `profileSetupProvider` | `Notifier<ProfileDraft>` | خطوات الإعداد؛ تُحفظ المسودة بعد كل خطوة |
| `readingsProvider` | `AsyncNotifier<List<SugarReading>>` | قائمة القراءات |
| `settingsProvider` | `Notifier<AppSettings>` | الحدود، الوحدات، وقت التذكير |

أي شاشة تعمل `ref.watch(settingsProvider)` تتحدث تلقائياً عند تغيير الإعدادات،
بدون الحاجة لإعادة التحميل يدوياً.

### إضافة ميزة جديدة

1. أنشئ `lib/features/<name>/` بالمجلدات `domain/`، `data/`، `presentation/`.
2. ابدأ بالموديل والمنطق في `domain/` واكتب له اختبار في `test/features/<name>/`.
3. أضف Repository في `data/` إذا كانت الميزة تحفظ بيانات.
4. أضف Notifier في `presentation/providers/` ثم الشاشات.
5. ميزة تحتاج شيئاً من ميزة أخرى؟ استورد الـ provider الخاص بها (مثل
   `DashboardScreen` يقرأ `settingsProvider`)، ولا تنسخ منطقها.

## الاختبارات

```
test/
├── test_helpers.dart            ← تخزين وهمي + FakeNotificationService
├── app_test.dart                ← أول شاشة حسب الحالة + التنقل بين خطوات الإعداد
└── features/
    ├── profile/                 ← العمر، JSON، controller الإعداد
    └── readings/                ← الإحصائيات، التصنيف، حفظ القراءات
```

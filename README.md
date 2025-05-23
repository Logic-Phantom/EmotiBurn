# EmotiBurn - 감정 해소를 위한 정신 건강 앱

## 프로젝트 소개
EmotiBurn은 감정 해소와 정신 건강 관리를 위한 Flutter 기반 모바일 애플리케이션입니다.

## 개발 환경
- Flutter SDK: >=3.0.0 <4.0.0
- Android SDK: 35
- Kotlin
- Gradle

## 주요 기능
- 로컬 알림
- 데이터 저장
- 게임 엔진 통합
- 상태 관리
- 커스텀 폰트
- 애니메이션
- 오디오 재생

## 의존성 패키지
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  flutter_local_notifications: ^17.0.0
  shared_preferences: ^2.2.2
  flame: ^1.14.0
  provider: ^6.1.1
  google_fonts: ^6.1.0
  flutter_animate: ^4.5.0
  audioplayers: ^5.2.1
```

## 빌드 과정 및 시행착오

### 1. 릴리즈 빌드 설정
#### 키스토어 생성
```powershell
cd android/app
keytool -genkey -v -keystore release.keystore -alias emotiburn -keyalg RSA -keysize 2048 -validity 10000
```
- 키스토어 비밀번호 설정 필요
- 조직 정보 입력 (CN, OU, O, L, ST, C)

#### build.gradle.kts 설정
```kotlin
signingConfigs {
    create("release") {
        storeFile = file("release.keystore")
        storePassword = System.getenv("KEYSTORE_PASSWORD") ?: "your_keystore_password"
        keyAlias = "emotiburn"
        keyPassword = System.getenv("KEY_PASSWORD") ?: "your_key_password"
    }
}
```

### 2. 환경 변수 설정
```powershell
$env:KEYSTORE_PASSWORD="your_keystore_password"
$env:KEY_PASSWORD="your_key_password"
```

### 3. 릴리즈 빌드 실행
```powershell
flutter build apk --release
```

### 4. APK 파일 위치
- `android/app/build/outputs/apk/release/app-release.apk`

## APK 설치 방법

### 1. APK 파일 전송
- USB 케이블 연결
- 이메일 전송
- 구글 드라이브 업로드
- 메신저 전송

### 2. 안드로이드 기기에서 설치
1. 파일 관리자 실행
2. APK 파일 위치로 이동
3. `app-release.apk` 파일 탭
4. "설치" 버튼 클릭
5. "알 수 없는 출처" 설치 허용
   - "설정" 클릭
   - "알 수 없는 출처" 또는 "이 출처 허용" 활성화
6. 설치 완료

## 주의사항
- 키스토어 파일과 비밀번호는 안전하게 보관
- 키스토어 파일 분실 시 앱 업데이트 불가능
- 비밀번호는 소스코드에 직접 입력하지 않기
- 환경 변수 사용 권장

## 프로젝트 구조
```
assets/
  ├── images/
  └── animations/
lib/
  ├── main.dart
  └── ...
android/
  └── app/
      ├── build.gradle.kts
      └── release.keystore
```

## 라이선스
이 프로젝트는 MIT 라이선스 하에 배포됩니다. 
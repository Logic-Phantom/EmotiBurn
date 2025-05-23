# EmotiBurn - 마음의 쓰레기통

감정을 버리는 행위 자체를 UX로 만든 감정 해방 앱

## 프로젝트 개요

사람들은 불안, 분노, 슬픔 같은 감정을 어디에도 말하지 못해 쌓아둡니다. 이 앱은 "감정을 버리는 행위 자체"를 UX로 만듭니다.

## 주요 기능

- 감정을 글로 작성한 후 "버리기" 버튼으로 삭제
- 버릴 때 종이가 타는 애니메이션 효과
- 버려진 감정은 저장되지 않음 (기억 대신 해주는 앱)
- 주기적으로 "지금 마음은 괜찮나요?" 푸시 알림

## 기술 스택

- Flutter
- Dart
- Provider (상태 관리)
- Flame (게임 엔진, 애니메이션)
- Flutter Local Notifications (푸시 알림)

## 프로젝트 구조

```
EmotiBurn/
├── lib/
│   ├── main.dart          # 앱의 진입점
│   ├── screens/           # 화면 위젯
│   ├── widgets/           # 재사용 가능한 위젯
│   ├── models/            # 데이터 모델
│   └── services/          # 비즈니스 로직
├── assets/
│   ├── images/           # 이미지 리소스
│   ├── animations/       # 애니메이션 리소스
│   └── sounds/           # 사운드 리소스
└── pubspec.yaml          # 프로젝트 설정 및 의존성
```

## 개발 현황

### 2024-03-21
- 프로젝트 초기 설정
- 기본 프로젝트 구조 생성
- 메인 화면 UI 구현
- 다크 모드 테마 적용

## 설치 및 실행

1. Flutter SDK 설치
2. 프로젝트 클론
```bash
git clone https://github.com/Logic-Phantom/EmotiBurn.git
```
3. 의존성 설치
```bash
flutter pub get
```
4. 앱 실행
```bash
flutter run
``` 
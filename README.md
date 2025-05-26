# EmotiBurn

EmotiBurn은 사용자의 감정 상태를 분석하고 이를 바탕으로 맞춤형 운동 추천을 제공하는 웹 애플리케이션입니다.

## 주요 기능

- 감정 상태 분석 및 기록
- 맞춤형 운동 추천
- 운동 일지 작성 및 관리
- 운동 통계 및 분석
- 커뮤니티 기능

## 기술 스택

- Frontend: React.js
- Backend: Node.js, Express.js
- Database: MongoDB
- AI/ML: TensorFlow.js (감정 분석)
- Authentication: JWT

## 프로젝트 구조

```
EmotiBurn/
├── client/                 # Frontend React 애플리케이션
│   ├── public/            # 정적 파일
│   └── src/               # 소스 코드
│       ├── components/    # React 컴포넌트
│       ├── pages/        # 페이지 컴포넌트
│       ├── services/     # API 서비스
│       └── utils/        # 유틸리티 함수
├── server/                # Backend 서버
│   ├── config/           # 설정 파일
│   ├── controllers/      # 컨트롤러
│   ├── models/          # 데이터 모델
│   ├── routes/          # API 라우트
│   └── utils/           # 유틸리티 함수
└── docs/                 # 문서
```

## 시작하기

### 필수 요구사항

- Node.js (v14 이상)
- MongoDB
- npm 또는 yarn

### 설치 및 실행

1. 저장소 클론
```bash
git clone https://github.com/yourusername/EmotiBurn.git
cd EmotiBurn
```

2. Frontend 의존성 설치 및 실행
```bash
cd client
npm install
npm start
```

3. Backend 의존성 설치 및 실행
```bash
cd server
npm install
npm start
```

## API 문서

API 문서는 `/docs/api.md`에서 확인할 수 있습니다.

## 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참조하세요.

## 최근 변경사항 (2024-07)

- Flutter/Flame 기반 감정 버리기 앱으로 구조 전환
- 한글 깨짐 현상 해결 (locale, supportedLocales, fontFamily, flutter_localizations 적용)
- OpacityProvider 오류(Unsupported operation: Can only apply this effect to OpacityProvider) 완전 해결
- Flame 1.28.x API 변화 대응 (Effect 완료 감지, 투명도 조절 등)
- pubspec.yaml 의존성 최신화 (flame, intl 등)
- 기타 빌드/런타임 호환성 개선

## 연락처

프로젝트 관리자 - dlacoaud96@gmail.com

프로젝트 링크: [https://github.com/yourusername/EmotiBurn](https://github.com/yourusername/EmotiBurn) 
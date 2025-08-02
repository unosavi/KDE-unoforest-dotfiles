**Languages:** [🇰🇷 한국어](./README_ko.md) | [🇺🇸 English](./README.md)

---

# KDE Dotfiles (Plasma 6) — 설정 가이드

이 저장소는 사용자 수준의 KDE/Plasma 설정 자산과 커스텀 패키지를 포함합니다. 민감한 정보(페어링 키, 토큰, 캐시)를 제외하여 안전하게 공개 공유할 수 있도록 관리됩니다. 새로운 기기에서 이 환경을 재현하려면 이 가이드를 따르세요.

**현재 저장소에 포함된 구성요소:**
- local Plasma Look-and-Feel 패키지: `local/plasma/look-and-feel/archsimpleblue`
- 다양한 커스텀 플라스모이드: `local/plasma/plasmoids/*`
- 테마 자산: `local/color-schemes/` 및 `unoforest_wallpapers/` 배경화면
- 앱별 설정: `config/fastfetch/`, `config/ghostty/`, `config/spicetify/`, panel-colorizer 프리셋
- 유틸리티 스크립트: `a.sh` (Wayland: KWin 불투명도 규칙 전환, 배경화면 변경, Ghostty 투명도 동기화)

누락된 항목이 있다면 "권장 KDE 파일" 섹션을 참고하여 필요에 따라 추가하세요.

## 대상 환경

- **KDE Plasma:** 6.x
- **KDE Frameworks:** 6.x  
- **디스플레이 세션:** Wayland (주력), X11 예비
- **배포판:** Arch Linux (다른 배포판에서도 범용 적용 가능)

사용 중인 시스템의 실제 Plasma/Framework 버전을 기록하고 필요시 업데이트하세요.

## 콘텐츠 구조

```
config/
├── fastfetch/          # 프로필
├── ghostty/            # 터미널 설정
├── spicetify/          # Spotify 테마
└── panel-colorizer/    # 패널 색상화 프리셋

local/
├── color-schemes/      # KDE 색상 스킴
└── plasma/
    ├── look-and-feel/archsimpleblue    # 커스텀 룩앤필 패키지
    └── plasmoids/
        ├── 12menu                      # 커스텀 런처
        ├── KdeControlStation           # 제어 센터
        ├── luisbocanegra.panel.colorizer       # 패널 색상화
        ├── luisbocanegra.panelspacer.extended  # 패널 스페이서
        └── org.dhruv8sh.kara          # kara 위젯

symbol/                 # 심볼/아이콘
unoforest_wallpapers/   # 배경화면
a.sh                    # Wayland 유틸리티 (창 불투명도, 배경화면 전환, Ghostty 동기화)
```

## 의도적 제외 항목

**저장소에 포함하지 않는 항목들:**
- 비밀 정보/토큰/키 (예: kdeconnect 개인 키)
- 세션 상태, 캐시, 잠금 파일
- 최근 사용 파일 기록
- 기기별 하드웨어/모니터 지오메트리 캐시 (예: 시리얼 번호가 포함된 KScreen)

## 권장 KDE 파일

KDE 데스크탑을 완전히 재현하려면 `$HOME`에서 다음 파일들을 추적하는 것을 고려하세요:

### 코어 Plasma 및 셸
```bash
~/.config/kdeglobals                                    # 전역 모양새 (색상, 아이콘, 글꼴, 로캘)
~/.config/plasmarc                                     # Plasma 셸 설정
~/.config/ksmserverrc                                  # 세션 관리자
~/.config/plasma-org.kde.plasma.desktop-appletsrc     # 패널 및 위젯 레이아웃
~/.config/kwinrc                                       # KWin (창 관리자), Wayland 제스처/효과
~/.config/kwinrulesrc                                  # KWin 창 규칙
~/.local/share/kscreen/*.json                          # 모니터 레이아웃 (선택사항)
```

### 입력, 단축키, 글꼴
```bash
~/.config/kglobalshortcutsrc                          # 전역 단축키
~/.config/khotkeysrc                                  # 고급 단축키
~/.config/kxkbrc                                      # 키보드 레이아웃
~/.config/kcminputrc                                  # 마우스/터치패드/커서
~/.config/kcmfonts                                    # 글꼴 설정
~/.config/fontconfig/*.conf                           # fontconfig 재정의
```

### 전원 및 로캘
```bash
~/.config/powermanagementprofilesrc
~/.config/plasma-localerc                             # 로캘/형식 재정의
```

### 자동 시작 & 사용자 서비스
```bash
~/.config/autostart/*.desktop
~/.config/systemd/user/*.service, *.timer
~/.config/plasma-workspace/env/*.sh
~/.config/environment.d/*.conf
```

## 민감 정보 제외 패턴

도트파일 버전 관리 시 다음을 제외하세요:

```gitignore
# KDE Connect 키
~/.config/kdeconnect/privateKey.pem
~/.config/kdeconnect/*/

# 번역 바이너리
**/contents/locale/*.mo

# 캐시/상태
~/.cache/**
~/.local/state/**

# 최근 문서
~/.local/share/RecentDocuments/**
```

## 설치 가이드

### 사전 요구 사항
- Plasma 6 데스크탑 세션 설치 완료
- **선택사항:** plasma-sdk, spicetify, fastfetch, ghostty
- **Arch Linux:** `pacman`/`aur` 통해 설치

### 자산 배포

#### 1️⃣ Look-and-Feel 패키지
```bash
# 룩앤필 패키지 복사
cp -r local/plasma/look-and-feel/archsimpleblue ~/.local/share/plasma/look-and-feel/

# 시스템 설정에서 적용: 모양새 → 전역 테마 → "Arch Simple Blue"
```

#### 2️⃣ 플라스모이드 (위젯)
```bash
# 각 플라스모이드를 해당 경로로 복사
cp -r local/plasma/plasmoids/* ~/.local/share/plasma/plasmoids/
```

**예시:**
- `12menu` → `~/.local/share/plasma/plasmoids/12menu`
- `KdeControlStation` → `~/.local/share/plasma/plasmoids/KdeControlStation`
- `luisbocanegra.panel.colorizer` → `~/.local/share/plasma/plasmoids/luisbocanegra.panel.colorizer`

#### 3️⃣ 색상 스킴 및 배경화면
```bash
# 색상 스킴 복사
cp local/color-schemes/*.colors ~/.local/share/color-schemes/

# 배경화면 복사 (경로는 Plasma 설정에 맞게 조정)
cp -r unoforest_wallpapers/ ~/.local/share/wallpapers/
```

#### 4️⃣ 앱 설정
```bash
# 심볼릭 링크 생성 (권장)
ln -s $(pwd)/config/fastfetch ~/.config/fastfetch
ln -s $(pwd)/config/ghostty ~/.config/ghostty
ln -s $(pwd)/config/spicetify ~/.config/spicetify
```

### 심볼릭 링크 모드 (권장)
```bash
# 저장소 루트에서 실행
ln -s <repo>/config/ghostty ~/.config/ghostty
ln -s <repo>/local/plasma/plasmoids/12menu ~/.local/share/plasma/plasmoids/12menu
```

**장점:** 업데이트가 간편하고 전체 컴포넌트 수준의 관리가 가능

## a.sh 유틸리티 스크립트

`a.sh`는 "nominal"(불투명) 모드와 "stealth"(투명) 모드 간의 빠른 전환을 제공합니다.

### 기능
- `~/.config/kwinrulesrc`의 불투명도 값을 읽고 업데이트 (85 ↔ 100)
- 배경화면 전환 (`plasma-apply-wallpaperimage` 또는 `kwriteconfig5` + DBus)
- Ghostty 설정 업데이트:
  - `background-opacity` (stealth: 0.85, nominal: 주석 처리)
  - `background-blur` (stealth: 50, nominal: 주석 처리)

### 사용법
```bash
# 실행 권한 부여
chmod +x ./a.sh

# 실행
./a.sh
```

### 커스터마이징
스크립트 상단의 변수를 편집하세요:
```bash
CONFIG_FILE="~/.config/kwinrulesrc"
GHOSTTY_CONFIG="~/.config/ghostty/config" 
NOMINAL_WALLPAPER="경로/이미지1.png"
STEALTH_WALLPAPER="경로/이미지2.png"
```

**팁:** 이식성을 위해 하드코딩된 경로를 `$HOME`으로 변경하세요.

## 설치 후 확인 사항

- [ ] 전역 테마가 Breeze로 대체되지 않고 정상 로드
- [ ] 패널과 위젯이 예상 위치에 표시
- [ ] 단축키가 예상대로 작동
- [ ] KDE 및 GTK 앱 전반의 글꼴/아이콘/테마 일관성
- [ ] Ghostty/fastfetch/spicetify가 제공된 설정으로 작동
- [ ] 깨진 배경화면 참조 없음

## 유지보수

**정기 점검:**
- 플라스모이드 패키지 업데이트 시 `metadata.json` 일관성 유지
- 배경화면/색상 스킴 변경 시 `kdeglobals` 및 `appletsrc` 참조 일치
- 캐시, 로컬 히스토리, 민감한 키 커밋 방지
- Plasma/Frameworks 버전 변경사항 추적

## 라이선스

**서드파티 패키지별 라이선스:**
- `local/plasma/look-and-feel/archsimpleblue`: GPLv3 (포함된 LICENSE 참조)
- 각 플라스모이드: 메타데이터에 명시된 개별 라이선스

## 추가 고려 항목

**향후 추가할 만한 구성요소:**
```bash
~/.config/kdeglobals                     # 민감 경로 정리 후
~/.config/plasma-org.kde.plasma.desktop-appletsrc
~/.config/kwinrc                         # 제스처/효과/규칙
~/.config/kglobalshortcutsrc            # 전역 단축키
~/.config/autostart/                     # 자동 시작 항목
~/.config/gtk-3.0/settings.ini          # GTK 일관성
~/.config/fcitx5/*                       # 입력기 (토큰 제외)
```

**중요:** 추가 시 사용자별 비밀 정보 및 기기별 캐시를 제거하세요.

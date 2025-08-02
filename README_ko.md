**Languages:** [🇰🇷 한국어](./README_ko.md) | [🇺🇸 English](./README.md)

---


KDE Dotfiles (Plasma 6) — 설정 가이드
이 저장소는 사용자 수준의 KDE/Plasma 설정 자산과 커스텀 패키지를 포함하고 있습니다. 민감한 정보(페어링 키, 토큰, 캐시)를 제외하여 안전하게 공개적으로 공유할 수 있도록 관리됩니다. 새로운 기기에서 이 환경을 재현하려면 다음 가이드를 따르세요.

참고: 현재 저장소 트리에는 다음이 이미 포함되어 있습니다:

로컬 Plasma 룩앤필(Look-and-Feel) 패키지: local/plasma/look-and-feel/archsimpleblue

local/plasma/plasmoids/* 경로 아래의 여러 커스텀 플라스모이드

local/color-schemes/와 같은 테마 자산 및 unoforest_wallpapers/ 아래의 배경화면

앱별 설정: config/fastfetch/, config/ghostty/, config/spicetify/, 그리고 panel-colorizer 프리셋

유틸리티 스크립트: a.sh (Wayland: KWin 불투명도 규칙 전환, 배경화면 변경, Ghostty 투명도 동기화)

만약 누락된 항목이 있다면, "포함할 것을 권장하는 KDE 파일" 섹션을 보고 필요에 따라 추가하세요.

대상 환경
KDE Plasma: 6.x

KDE Frameworks: 6.x

디스플레이 세션: Wayland (주력), X11은 예비용으로 사용 가능

배포판: Arch Linux (하지만 다른 배포판에서도 일반적으로 적용 가능한 단계들입니다)

사용 중인 시스템의 실제 Plasma/Frameworks 버전을 기록하고, 필요한 경우 여기를 업데이트하세요.

콘텐츠 개요
config/

fastfetch/ (프로필)

ghostty/ (터미널 설정)

spicetify/ (Spotify 테마)

panel-colorizer/ (패널 색상화 프리셋)

local/

color-schemes/ (KDE 색상 스킴)

plasma/

look-and-feel/archsimpleblue (커스텀 룩앤필 패키지)

plasmoids/

12menu (커스텀 런처)

KdeControlStation (제어 센터)

luisbocanegra.panel.colorizer (패널 색상화)

luisbocanegra.panelspacer.extended (패널 스페이서)

org.dhruv8sh.kara (kara 위젯)

symbol/ (사용된 심볼/아이콘)

unoforest_wallpapers/ (배경화면)

a.sh (Wayland에서 창 불투명도, 배경화면 전환 및 Ghostty 동기화를 위한 유틸리티)

의도적으로 제외된 항목
다음 항목들은 저장소에 저장하지 마세요:

비밀 정보/토큰/키 (예: kdeconnect 개인 키)

세션 상태, 캐시, 잠금 파일

최근 사용 파일 기록

기기별 하드웨어/모니터 지오메트리 캐시 (예: 시리얼 번호가 포함된 KScreen), 확정적인 화면 레이아웃이 정말 필요한 경우가 아니라면 제외

포함할 것을 권장하는 KDE 파일
KDE 데스크탑을 완전히 재현하려면 $HOME에서 다음 파일들을 추적하는 것을 고려하세요 (추가하기 전에 내용을 검토하세요):

코어 Plasma 및 셸

~/.config/kdeglobals — 전역 모양새 (색상, 아이콘, 글꼴, 로캘)

~/.config/plasmarc — Plasma 셸 설정

~/.config/ksmserverrc — 세션 관리자

~/.config/plasma-org.kde.plasma.desktop-appletsrc — 패널 및 위젯 레이아웃

~/.config/kwinrc — KWin (창 관리자), Wayland 제스처/효과

~/.config/kwinrulesrc — KWin 창 규칙

~/.local/share/kscreen/*.json — 모니터 레이아웃 (선택사항; 기기별로 다름)

입력, 단축키, 글꼴

~/.config/kglobalshortcutsrc — 전역 단축키

~/.config/khotkeysrc — 고급 단축키

~/.config/kxkbrc — 키보드 레이아웃

~/.config/kcminputrc — 마우스/터치패드/커서

~/.config/kcmfonts — 글꼴 설정

~/.config/fontconfig/*.conf — fontconfig 재정의

전원 및 로캘

~/.config/powermanagementprofilesrc

~/.config/plasma-localerc — 로캘/형식 재정의

자동 시작 & 사용자 서비스

~/.config/autostart/*.desktop

~/.config/systemd/user/*.service, *.timer

~/.config/plasma-workspace/env/*.sh 또는 ~/.config/environment.d/*.conf

KDE 애플리케이션 (선택사항이지만 유용함)

Dolphin: ~/.config/dolphinrc 및 ~/.local/share/dolphin/view_properties/global/.directory

Spectacle: ~/.config/spectaclerc

Kate: ~/.config/katerc, ~/.config/kateprojectsrc

Okular: ~/.config/okularpartrc

Gwenview: ~/.config/gwenviewrc

Konsole (사용 시): ~/.config/konsolerc, ~/.local/share/konsole/*.profile

GTK 일관성 (선택사항)

~/.config/gtk-3.0/settings.ini

~/.config/gtk-4.0/settings.ini

해당하는 GTK 테마/아이콘

입력기 (사용 시)

~/.config/fcitx5/* (config, profile, addon.conf)

제외할 민감한 패턴
도트파일을 버전 관리할 때 다음을 제외하세요:

kdeconnect 키: ~/.config/kdeconnect/privateKey.pem, 기기별 디렉토리

플라스모이드 contents/locale/ 폴더 안의 모든 *.mo 컴파일된 번역 바이너리

캐시/상태: ~/.cache/**, ~/.local/state/**, plasma 셸 캐시

최근 문서 목록: ~/.local/share/RecentDocuments/**

아직 없다면 이러한 패턴을 포함하는 .gitignore 파일을 추가하세요.

설치 가이드
이 가이드는 저장소를 작업 디렉토리에 복제(clone)했고, 이를 $HOME에 배포하려는 상황을 가정합니다. 심볼릭 링크로 관리되는 도트파일 설정을 선호한다면, 아래의 "심볼릭 링크 모드"로 전환하세요.

사전 요구 사항

Plasma 6 데스크탑 세션이 설치되어 있어야 함

선택사항: plasma-sdk (plasmoidviewer용), spicetify, fastfetch, ghostty

Arch Linux 사용자는 필요에 따라 pacman/aur을 통해 설치할 수 있습니다.

자산 배포

룩앤필(Look-and-Feel) 패키지

local/plasma/look-and-feel/archsimpleblue 디렉토리 전체를 다음 경로로 복사합니다:
~/.local/share/plasma/look-and-feel/archsimpleblue

시스템 설정 → 모양새 → 전역 테마에서 “Arch Simple Blue”를 선택합니다 (또는 제공된 자산이 시작 화면뿐이라면 그것만 설정합니다).

플라스모이드 (위젯)

local/plasma/plasmoids/* 아래의 각 디렉토리를 다음 경로로 복사합니다:
~/.local/share/plasma/plasmoids/<packageId>
예시:

12menu → ~/.local/share/plasma/plasmoids/12menu

KdeControlStation → ~/.local/share/plasma/plasmoids/KdeControlStation

luisbocanegra.panel.colorizer → ~/.local/share/plasma/plasmoids/luisbocanegra.panel.colorizer

luisbocanegra.panelspacer.extended → ~/.local/share/plasma/plasmoids/luisbocanegra.panelspacer.extended

org.dhruv8sh.kara → ~/.local/share/plasma/plasmoids/org.dhruv8sh.kara

색상 스킴 및 배경화면

local/color-schemes/*.colors 파일들을 다음 경로로 복사합니다:
~/.local/share/color-schemes/

unoforest_wallpapers/ 콘텐츠를 배경화면 위치로 복사하고, Plasma 배경 설정이 올바른 경로를 가리키도록 합니다. ~/.local/share/wallpapers 내의 상대 경로를 사용하거나, 동일한 폴더 구조를 유지하고 appletsrc 참조를 조정하는 것이 좋습니다.

앱 설정

config/fastfetch/를 ~/.config/fastfetch/에 병합하거나 심볼릭 링크를 생성합니다.

config/ghostty/를 ~/.config/ghostty/에 병합하거나 심볼릭 링크를 생성합니다.

config/spicetify/를 ~/.config/spicetify/에 병합하거나 심볼릭 링크를 생성합니다.

config/panel-colorizer/를 특정 위젯에서 요구하는 경우 호환되는 위치에 병합하거나 심볼릭 링크를 생성합니다.

Plasma 레이아웃 및 설정 (선택사항, 고급)

plasma-org.kde.plasma.desktop-appletsrc, kdeglobals, kwinrc와 같은 파일을 추적하기로 결정했다면 다음을 확인하세요:

appletsrc에 나열된 플라스모이드가 ~/.local/share/plasma/plasmoids에 존재해야 합니다.

kdeglobals의 ColorScheme이 ~/.local/share/color-schemes/에 있는 파일과 일치해야 합니다.

배경화면 경로가 유효해야 합니다.

설정 파일을 배치한 후, plasmashell을 재시작하거나 로그아웃 후 다시 로그인하세요.

심볼릭 링크 모드 (반복 가능한 설정을 위해 권장)

저장소 루트에서 $HOME으로 심볼릭 링크를 생성합니다. 예시:

Bash

ln -s <repo>/config/ghostty ~/.config/ghostty
ln -s <repo>/local/plasma/plasmoids/12menu ~/.local/share/plasma/plasmoids/12menu
업데이트를 간단하게 유지하기 위해 전체 컴포넌트에 대해 디렉토리 수준의 심볼릭 링크를 사용하는 것을 선호합니다.

링크를 걸기 전에 기존 디렉토리를 백업하세요.

Systemd 사용자 서비스 (추가하는 경우)

유닛 파일들을 ~/.config/systemd/user/ 아래에 배치합니다.

데몬을 다시 로드하고 서비스를 활성화/시작합니다:

Bash

systemctl --user daemon-reload
systemctl --user enable --now service-name.service
a.sh 유틸리티 스크립트
a.sh는 KWin 규칙 변경, 배경화면 전환, Ghostty 투명도/블러 동기화를 통해 "nominal"(불투명) 모드와 "stealth"(투명) 모드 간의 빠른 전환을 제공합니다.

기능

~/.config/kwinrulesrc의 opacityactive/opacityinactive 값을 읽고 업데이트합니다 (85 ↔ 100).

plasma-apply-wallpaperimage가 있으면 이를 사용해 배경화면을 변경하고, 없으면 kwriteconfig5 + DBus 리프레시로 대체 작동합니다.

Ghostty 설정 파일(~/.config/ghostty/config)의 다음 키를 업데이트합니다:

background-opacity (stealth 모드일 때 0.85; nominal 모드일 때 주석 처리)

background-blur (stealth 모드일 때 50; nominal 모드일 때 주석 처리)

KWin 재설정을 트리거하고 데스크탑 알림을 보냅니다.

스크립트 위치

저장소 루트: ./a.sh

요구 사항

KDE Plasma 6 세션 (Wayland)

도구: plasma-apply-wallpaperimage (선택사항이지만 권장), kwriteconfig5, dbus-send, notify-send

터미널 투명도 동기화를 사용하려면 Ghostty가 설치되어 있어야 합니다 (선택사항).

사용법

실행 권한을 부여합니다:

Bash

chmod +x ./a.sh
실행합니다:

Bash

./a.sh
동작:

현재 불투명도가 85이면 → 100(nominal/불투명)으로 전환하고 NOMINAL_WALLPAPER를 적용합니다.

그렇지 않으면 → 85(stealth/투명)로 전환하고 STEALTH_WALLPAPER를 적용합니다.

사용자화

a.sh 상단의 변수를 편집하세요:

CONFIG_FILE (기본값: ~/.config/kwinrulesrc)

GHOSTTY_CONFIG (기본값: ~/.config/ghostty/config)

NOMINAL_WALLPAPER, STEALTH_WALLPAPER — 원하는 이미지로 설정하세요.

팁: 이식성을 위해 하드코딩된 /home/unoverse 경로를 $HOME으로 바꾸세요.

주의사항

대체 작동하는 kwriteconfig5 경로는 특정 containment/group ID를 가정하므로 시스템마다 다를 수 있습니다.

notify-send 오류를 피하려면 배경화면 파일이 존재하는지 확인하세요.

처음 사용하기 전에 kwinrulesrc를 백업하세요.

설치 후 확인 사항
전역 테마가 Breeze로 대체되지 않고 정상적으로 로드되는지 확인

패널과 위젯이 예상된 위치에 나타나는지 확인

단축키가 예상대로 작동하는지 확인

KDE 및 GTK 앱 전반에 걸쳐 글꼴/아이콘/테마가 일관성 있는지 확인

Ghostty/fastfetch/spicetify가 제공된 설정으로 작동하는지 확인

깨진 배경화면 참조가 없는지 확인

유지보수
플라스모이드 패키지를 업데이트하고 metadata.json/metadata.desktop 파일의 일관성을 유지하세요.

배경화면이나 색상 스킴을 변경할 때, kdeglobals와 appletsrc 참조를 일치시키세요.

캐시, 로컬 히스토리, 민감한 키를 커밋하지 마세요.

설정 키에 영향을 줄 수 있는 Plasma/Frameworks의 버전 변경 사항을 추적하세요.

라이선스 정보
서드파티 패키지들은 자체 라이선스를 가집니다. 예를 들어:

local/plasma/look-and-feel/archsimpleblue는 GPLv3입니다 (포함된 LICENSE 파일 참조).

각 플라스모이드는 메타데이터에 자체 라이선스를 명시하고 있습니다.

다음에 추가할 만한 항목
(민감한 경로를 정리한 후) ~/.config/kdeglobals, ~/.config/plasma-org.kde.plasma.desktop-appletsrc 스냅샷

~/.config/kwinrc (제스처/효과/규칙), ~/.config/kglobalshortcutsrc

~/.config/powermanagementprofilesrc, ~/.config/plasma-localerc

~/.config/autostart/ 아래의 자동 시작 항목

~/.config/gtk-3.0/settings.ini 및 ~/.config/gtk-4.0/settings.ini

fcitx5를 사용하는 경우: ~/.config/fcitx5/* (토큰 제외)

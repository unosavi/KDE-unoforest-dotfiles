#!/bin/bash

# KDE Wayland 환경에서 창 투명도를 토글하고 바탕화면을 변경하는 스크립트
CONFIG_FILE="/home/unoverse/.config/kwinrulesrc"
GHOSTTY_CONFIG="/home/unoverse/.config/ghostty/config"

# 바탕화면 경로 설정
NOMINAL_WALLPAPER="/home/unoverse/Pictures/wp/wall/1.png"
STEALTH_WALLPAPER="/home/unoverse/Pictures/wp/wall/2.png"

# 현재 투명도 설정을 확인
current_opacity=$(grep "opacityactive=" "$CONFIG_FILE" | head -n 1 | cut -d'=' -f2)

# 바탕화면 변경 함수
change_wallpaper() {
  local new_wallpaper="$1"

  # 파일이 존재하는지 확인
  if [ ! -f "$new_wallpaper" ]; then
    notify-send "오류" "작전 명령서가 존재하지 않습니다: $new_wallpaper"
    return 1
  fi

  # Plasma 6에서는 plasma-apply-wallpaperimage 사용 (출력 숨김)
  if command -v plasma-apply-wallpaperimage &> /dev/null; then
    plasma-apply-wallpaperimage "$new_wallpaper" > /dev/null 2>&1
  else
    # 대체 방법으로 직접 설정 파일 수정
    kwriteconfig5 --file "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" --group "Containments" --group "1" --group "Wallpaper" --group "org.kde.image" --group "General" --key "Image" "$new_wallpaper"

    # 바탕화면 갱신
    dbus-send --session --dest=org.kde.plasmashell --type=method_call /PlasmaShell org.kde.PlasmaShell.refreshCurrentShell &> /dev/null || true
  fi
}

# Ghostty 투명도 설정 토글 함수 (개선된 버전)
toggle_ghostty_transparency() {
  local mode="$1"

  # Ghostty 설정 파일이 존재하는지 확인
  if [ ! -f "$GHOSTTY_CONFIG" ]; then
    return 1
  fi

  # 임시 파일 생성
  local temp_file=$(mktemp)

  if [ "$mode" = "stealth" ]; then
    # 평시모드 (투명): 투명도/블러 활성화

    # background-opacity 처리
    if grep -q "^background-opacity" "$GHOSTTY_CONFIG"; then
      # 이미 존재하면 값을 0.85로 변경
      sed 's/^background-opacity = [0-9.]*$/background-opacity = 0.85/' "$GHOSTTY_CONFIG" > "$temp_file"
      mv "$temp_file" "$GHOSTTY_CONFIG"
    elif grep -q "^#background-opacity" "$GHOSTTY_CONFIG"; then
      # 주석 처리된 것이 있으면 주석 해제하고 값 설정
      sed 's/^#background-opacity.*$/background-opacity = 0.85/' "$GHOSTTY_CONFIG" > "$temp_file"
      mv "$temp_file" "$GHOSTTY_CONFIG"
    else
      # 없으면 추가
      echo "background-opacity = 0.85" >> "$GHOSTTY_CONFIG"
    fi

    # background-blur 처리
    if grep -q "^background-blur" "$GHOSTTY_CONFIG"; then
      # 이미 존재하면 값을 50으로 변경
      sed 's/^background-blur = [0-9]*$/background-blur = 50/' "$GHOSTTY_CONFIG" > "$temp_file"
      mv "$temp_file" "$GHOSTTY_CONFIG"
    elif grep -q "^#background-blur" "$GHOSTTY_CONFIG"; then
      # 주석 처리된 것이 있으면 주석 해제하고 값 설정
      sed 's/^#background-blur.*$/background-blur = 50/' "$GHOSTTY_CONFIG" > "$temp_file"
      mv "$temp_file" "$GHOSTTY_CONFIG"
    else
      # 없으면 추가
      echo "background-blur = 50" >> "$GHOSTTY_CONFIG"
    fi

  else
    # 전시태세 (불투명): 투명도/블러 비활성화 (주석 처리)

    # background-opacity를 주석 처리
    if grep -q "^background-opacity" "$GHOSTTY_CONFIG"; then
      sed 's/^background-opacity/#background-opacity/' "$GHOSTTY_CONFIG" > "$temp_file"
      mv "$temp_file" "$GHOSTTY_CONFIG"
    fi

    # background-blur를 주석 처리
    if grep -q "^background-blur" "$GHOSTTY_CONFIG"; then
      sed 's/^background-blur/#background-blur/' "$GHOSTTY_CONFIG" > "$temp_file"
      mv "$temp_file" "$GHOSTTY_CONFIG"
    fi
  fi

  # 임시 파일이 남아있다면 정리
  [ -f "$temp_file" ] && rm -f "$temp_file"
}

# 투명도 토글 함수
toggle_opacity() {
  echo "현재 투명도: $current_opacity"

  if [ "$current_opacity" = "85" ]; then
    # 투명(85) → 불투명(100) 전시태세로 변경
    sed -i 's/opacityactive=85/opacityactive=100/g' "$CONFIG_FILE"
    sed -i 's/opacityinactive=85/opacityinactive=100/g' "$CONFIG_FILE"

    # 전시태세: 바탕화면을 1.png로 변경
    change_wallpaper "$NOMINAL_WALLPAPER"

    # Ghostty 투명도 비활성화 (주석 처리)
    toggle_ghostty_transparency "nominal"

    echo "상황발생, 전시태세 돌입"
  else
    # 불투명(100) → 투명(85) 평시로 변경
    sed -i 's/opacityactive=100/opacityactive=85/g' "$CONFIG_FILE"
    sed -i 's/opacityinactive=100/opacityinactive=85/g' "$CONFIG_FILE"

    # 평시: 바탕화면을 2.png로 변경
    change_wallpaper "$STEALTH_WALLPAPER"

    # Ghostty 투명도 활성화 (주석 해제)
    toggle_ghostty_transparency "stealth"

    echo "작전종료, 평시 전환"
  fi

  # 다른 효과들이 항상 적용되도록 보장
  # 최소 크기 설정 (0x0)
  sed -i 's/minsizerule=[0-9]*/minsizerule=2/g' "$CONFIG_FILE"

  # 제목표시줄 및 프레임 없음
  sed -i 's/noborder=[a-z]*/noborder=true/g' "$CONFIG_FILE"
  sed -i 's/noborderrule=[0-9]*/noborderrule=2/g' "$CONFIG_FILE"

  # 색 구성표: Everforest
  sed -i 's/decocolor=.*/decocolor=Everforest/g' "$CONFIG_FILE"
  sed -i 's/decocolorrule=[0-9]*/decocolorrule=2/g' "$CONFIG_FILE"

  # KWin 규칙을 다시 로드하기 위해 KWin 재시작
  dbus-send --session --dest=org.kde.KWin --type=method_call /KWin org.kde.KWin.reconfigure

  # 변경사항 알림
  if [ "$current_opacity" = "85" ]; then
    notify-send "작전 변경" "作戰状況 (작전경로: $(basename "$NOMINAL_WALLPAPER"))"
  else
    notify-send "작전 변경" "平時状況 (작전경로: $(basename "$STEALTH_WALLPAPER"))"
  fi
}

# 투명도 토글 실행
toggle_opacity

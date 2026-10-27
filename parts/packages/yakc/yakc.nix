{
  lib,
  stdenv,
  rustPlatform,
  pkg-config,
  makeWrapper,
  wrapGAppsHook3,
  gtk3,
  glib,
  glib-networking,
  libsoup_3,
  webkitgtk_4_1,
  libxkbcommon,
  libayatana-appindicator,
  speechd,
  udev,
  src,
}:

let
  cargoRoot = "src-tauri";

  manifest = fromTOML (builtins.readFile "${src}/${cargoRoot}/Cargo.toml");

  version = manifest.package.version;

  runtimeLibraries = [
    stdenv.cc.cc.lib
    gtk3
    glib
    glib-networking
    libsoup_3
    webkitgtk_4_1
    libxkbcommon
    libayatana-appindicator
    speechd
    udev
  ];
in
rustPlatform.buildRustPackage {
  pname = "yakc";
  inherit version src cargoRoot;
  cargoLock.lockFile = "${src}/${cargoRoot}/Cargo.lock";
  buildAndTestSubdir = cargoRoot;
  nativeBuildInputs = [
    pkg-config
    makeWrapper
    wrapGAppsHook3
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    gtk3
    glib
    glib-networking
    libsoup_3
    webkitgtk_4_1
    libxkbcommon
    libayatana-appindicator
    speechd
    udev
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH :
      "${lib.makeLibraryPath runtimeLibraries}"
    )
  '';

  postInstall = ''
    install -Dm644 \
      "${src}/${cargoRoot}/icons/icon.png" \
      "$out/share/pixmaps/yakc.png"

    install -Dm644 /dev/stdin \
      "$out/share/applications/yakc.desktop" <<'EOF'
    [Desktop Entry]
    Name=YAKC
    Comment=Keyboard and mouse input visualizer
    Exec=yakc
    Icon=yakc
    Terminal=false
    Type=Application
    Categories=Utility;
    EOF
  '';

  meta = {
    description = "YAKC - Yet Another Key Caster";
    homepage = "https://github.com/iammodev/YAKC";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "yakc";
  };
}

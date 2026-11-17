{ config, extraLib, ... }:

let
  cfg = config.homeDesktop;
  core = config.homeCore;
  font = core.font;
  inherit (extraLib.hyprland) hypr;

  styles = hypr.getVarValues config "styles";

  offset = 2 * styles.margin_out;
in
{
  programs.yakc = {
    enable = cfg.enable;
    settings = {
      displayMode = "raw";
      displayStyle = "popups";
      showOnMonitor = 0;
      showOverlayOnScreen = true;
      onlyKeysWithModifiers = false;
      keyboardLayout = core.keyboardLayout;
      toggleCaptureHotkey = "Alt+/";

      showKeyboardClick = true;
      showMouseClick = false;
      showMouseScroll = false;
      showMouseMovement = false;
      showMouseCoordinates = false;
      showGamepad = false;
      showSpaceAsUnicode = true;
      textToSymbols = true;

      position = "bottom-right";
      topOffset = offset + 40;
      bottomOffset = offset;
      leftOffset = offset;
      rightOffset = offset;

      popupTextMaxWidthInPercentage = 100.0;
      popupBorderRadius = styles.border_radius;
      popupOpacity = styles.opacity;
      popupFadeInSeconds = 0.15;
      popupRemoveAfterSeconds = 3.0;
      popupInactiveAfterSeconds = 0.75;

      popupFontSize = font.sizes.xl;
      popupFontFamily = font.family.sans_serif;
      popupFontWeight = "bold";
      popupFontColor = "#ffffff";
      popupBackgroundColor = "#000000";

      filter = false;
      filterProcessName = [ ];
      filterCheckEverySecond = 0.5;

      mouseMovementSensitivity = 1.0;
      mouseMovementDecaySeconds = 0.4;
      deviceWidgetScale = 1.0;

      textToSpeech = false;
      textToSpeechCancelSpeechOnNewKey = false;

      keyboardVisibleKeys = [ ];
      keyLabelOverrides = {
        meta = "MOD";
      };

      widgetPositions = { };
      snapToGuides = true;

      obsServerEnabled = false;
      obsServerPort = 7238;
    };
  };
}

{
  pkgs,
  ...
}:
{
  config = {
    # Communication and social media packages
    environment.systemPackages = with pkgs; [
      # Web browsers
      firefox
      chromium

      # Email
      thunderbird

      # Chat and messaging
      discord
      vesktop
      telegram-desktop

      # File sharing
      localsend
    ];
  };
}

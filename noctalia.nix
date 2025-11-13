{ pkgs, noctalia, ... }:
{
  environment.systemPackages = with pkgs; [
    noctalia.packages.${pkgs.system}.default
  ];
}

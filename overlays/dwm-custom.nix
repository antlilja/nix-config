self: super:
{
  dwm = super.dwm.overrideAttrs (old: {
    src = super.fetchFromGitHub {
      owner = "antlilja";
      repo = "dwm-custom";
      rev = "d56355a74bec47ddd0d4cf7fbc1e3595fb3176bf";
      sha256 = "sha256-hvM46pwzGXIXhpI5ok0/M5bvgJl2LwzKfuB+eSkkNYA";
    };
  });
}

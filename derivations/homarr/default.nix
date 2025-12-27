{
  stdenv,
  nodejs,
  # This is pinned as { pnpm = pnpm_9; }
  pnpm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "foo";
  version = "0-unstable-1980-01-01";

  src = {
    #...
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "...";
  };
})
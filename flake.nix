{
  description = "Build GRUB rescue image";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
  };

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.grubrescue = (
        let
            system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
        in
          pkgs.stdenv.mkDerivation {
              name = "grubrescue";
              buildInputs = with pkgs; [
                grub2 grub2_efi xorriso mtools
                  ];
              phases = ["buildPhase"];
              buildPhase = ''
              mkdir -p $out
              ${pkgs.grub2}/bin/grub-mkrescue --output $out/grub-rescue-i386-pc.img
              ${pkgs.grub2_efi}/bin/grub-mkrescue --output $out/grub-rescue-x86_64-efi.img
              '';
          }
        );

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.grubrescue;
  };
}

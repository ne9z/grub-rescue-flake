{
  description = "Build GRUB rescue image";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11"; };

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.grubrescue = (let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in pkgs.stdenv.mkDerivation {
      name = "grubrescue";
      src = ./.;
      buildInputs = with pkgs; [ grub2 grub2_efi xorriso mtools libfaketime ];
      phases = [ "unpackPhase" "buildPhase" ];
      buildPhase = ''
        mkdir -p $out
        export LD_PRELOAD=${pkgs.libfaketime}/lib/libfaketime.so.1
        export FAKETIME="1970-01-01 00:00:00"
        ${pkgs.grub2}/bin/grub-mkrescue --output $out/grub-rescue-i386-pc.img iso
        ${pkgs.grub2_efi}/bin/grub-mkrescue --output $out/grub-rescue-x86_64-efi.img iso
      '';
    });

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.grubrescue;
  };
}

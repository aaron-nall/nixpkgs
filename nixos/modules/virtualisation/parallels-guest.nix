{ config, lib, pkgs, ... }:

with lib;

let
  prl-tools = config.hardware.parallels.package;
in

{

  imports = [
    (mkRemovedOptionModule [ "hardware" "parallels" "autoMountShares" ] "Shares are always automatically mounted since Parallels Desktop 20.")
  ];

  options = {
    hardware.parallels = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          This enables Parallels Tools for Linux guests, along with provided
          video, mouse and other hardware drivers.
        '';
      };

      package = mkOption {
        type = types.nullOr types.package;
        default = config.boot.kernelPackages.prl-tools;
        defaultText = "config.boot.kernelPackages.prl-tools";
        example = literalExpression "config.boot.kernelPackages.prl-tools";
        description = ''
          Defines which package to use for prl-tools. Override to change the version.
        '';
      };
    };

  };

  config = mkIf config.hardware.parallels.enable {

    services.udev.packages = [ prl-tools ];

    environment.systemPackages = [ prl-tools ];

    boot.extraModulePackages = [ prl-tools ];

    boot.kernelModules = [ "prl_fs" "prl_fs_freeze" "prl_tg" ]
      ++ optional (pkgs.stdenv.hostPlatform.system == "aarch64-linux") "prl_notifier";

    services.timesyncd.enable = false;

    systemd.services.prltoolsd = {
      description = "Parallels Tools Service";
      wantedBy = [ "multi-user.target" ];
      path = [ prl-tools ];
      serviceConfig = {
        ExecStart = "${prl-tools}/bin/prltoolsd -f";
        PIDFile = "/var/run/prltoolsd.pid";
        WorkingDirectory = "${prl-tools}/bin";
      };
    };

    # systemd.services.prlfsmountd = mkIf config.hardware.parallels.autoMountShares {
    #   description = "Parallels Guest File System Sharing Tool";
    #   wantedBy = [ "multi-user.target" ];
    #   path = [ prl-tools ];
    #   serviceConfig = rec {
    #     ExecStart = "${prl-tools}/sbin/prlfsmountd ${PIDFile}";
    #     ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /media";
    #     ExecStopPost = "${prl-tools}/sbin/prlfsmountd -u";
    #     PIDFile = "/run/prlfsmountd.pid";
    #     WorkingDirectory = "${prl-tools}/bin";
    #   };
    # };

    # systemd.services.prlshprint = {
    #   description = "Parallels Printing Tool";
    #   wantedBy = [ "multi-user.target" ];
    #   bindsTo = [ "cups.service" ];
    #   path = [ prl-tools ];
    #   serviceConfig = {
    #     ExecStart = "${prl-tools}/bin/prlshprint";
    #     WorkingDirectory = "${prl-tools}/bin";
    #   };
    # };

    systemd.user.services = {
      prlcc = {
        description = "Parallels Control Center";
        wantedBy = [ "graphical-session.target" ];
        path = [ prl-tools ];
        serviceConfig = {
          ExecStart = "${prl-tools}/bin/prlcc";
          WorkingDirectory = "${prl-tools}/bin";
        };
      };
      prldnd = {
        enable = false;
        description = "Parallels Drag And Drop Tool";
        wantedBy = [ "graphical-session.target" ];
        path = [ prl-tools ];
        serviceConfig = {
          ExecStart = "${prl-tools}/bin/prldnd";
          WorkingDirectory = "${prl-tools}/bin";
        };
      };
      prlcp = {
        enable = false;
        description = "Parallels Copy Paste Tool";
        wantedBy = [ "graphical-session.target" ];
        path = [ prl-tools ];
        serviceConfig = {
          ExecStart = "${prl-tools}/bin/prlcp";
          Restart = "always";
          WorkingDirectory = "${prl-tools}/bin";
        };
      };
      prlsga = {
        enable = false;
        description = "Parallels Shared Guest Applications Tool";
        wantedBy = [ "graphical-session.target" ];
        path = [ prl-tools ];
        serviceConfig = {
          ExecStart = "${prl-tools}/bin/prlsga";
          WorkingDirectory = "${prl-tools}/bin";
        };
      };
      prlshprof = {
        enable = false;
        description = "Parallels Shared Profile Tool";
        wantedBy = [ "graphical-session.target" ];
        path = [ prl-tools ];
        serviceConfig = {
          ExecStart = "${prl-tools}/bin/prlshprof";
          WorkingDirectory = "${prl-tools}/bin";
        };
      };
    };

  };
}

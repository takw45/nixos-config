# NixOS Config
## インストール手順

1. 起動ディスクの作成
1. GitリポジトリのClone
1. ハードディスクのパーティション分割
1. OSインストール
1. パスワード変更

### 起動ディスクの作成
1. https://nixos.org/download/ からGraphical ISOイメージをダウンロード
1. USBメモリに焼く.
1. USBメモリをインストールするマシンに接続してマシンを起動

### GitリポジトリのClose
マシン起動後OSのインストーラが立ち上がるが閉じる.ターミナルを開いて,このリポジトリをClone

### ハードディスクのパーティション分割

```shell
sudo nix --extra-experimental-features "nix-command flakes" \
  run github:nix-community/disko/latest#disko-install -- \
  --flake .#laptop \
  --disk main /dev/nvme0n1
```
途中でディスク暗号化用のパスワード入力が求められるのでパスワードを入力する.

### OSインストール

```shell
sudo nixos-install --flake .#laptop
```
こちらも途中でroot用のパスワード入力が求められるのでパスワードを入力.

インストールが完了したら`reboot`する

### パスワード変更
再起動後, 初期パスワードでログイン
```shell
passwd
```
でパスワードを変更する.
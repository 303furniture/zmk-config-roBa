# zmk-config-roBa

## `west forall` で変更のあるプロジェクトだけ確認する

`west forall` は、サブモジュールのいずれかに変更があるときにまとめて確認するのに便利ですが、`test -n "$(git status --porcelain)" && ...` のようなワンライナーだと、変更が無いプロジェクトで `exit 1` になり、`west` がエラー終了してしまいます。常に `exit 0` で終わるようにしつつ、変更があるプロジェクトだけを表示するには以下のコマンドを使ってください。

### プロジェクト名だけ知りたい場合（推奨）

```sh
west forall -q -c 'if [ -n "$(git status --porcelain)" ]; then echo "$WEST_PROJECT_NAME"; fi; exit 0'
```

### 変更の内容も一緒に見たい場合

```sh
west forall -q -c '
  s="$(git status --porcelain)"
  if [ -n "$s" ]; then
    echo "### $WEST_PROJECT_NAME"
    echo "$s"
  fi
  exit 0
'
```

どちらのコマンドも最後に `exit 0` することで、変更が無いプロジェクトでも `west forall` 全体が成功扱いになります。

### スクリプトとして使う場合

リポジトリ直下の `scripts/west-dirty.sh` でも同じ処理を行えるようにしています。トップディレクトリを指す `WEST_TOPDIR` を使って実行すると便利です。

```sh
west forall -q -c '$WEST_TOPDIR/scripts/west-dirty.sh'
```

変更内容も一緒に確認したいときは `--show-details` を付けてください。

```sh
west forall -q -c '$WEST_TOPDIR/scripts/west-dirty.sh --show-details'
```

スクリプト内部でも必ず `exit 0` で終了するため、変更が無いプロジェクトでも `west forall` が失敗扱いになることはありません。

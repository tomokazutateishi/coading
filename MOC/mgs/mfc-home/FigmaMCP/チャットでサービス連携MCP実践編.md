# チャットでサービス連携！MCP実践編

## [](https://qiita.com/kurata04/items/2d3a0f803b20bd56be18#%E3%81%AF%E3%81%98%E3%82%81%E3%81%AB)はじめに

基礎編は以下の記事を参照ください。

実践編ではいくつかのサービスを利用してMCPを実際に利用してみます。  
利用するサービスは以下の通りです。

-   GitHub
-   AWS
-   Backlog
-   Figma

また、外部連携以外に自分でMCPサーバーを作成して利用する方法も紹介します。

## [](https://qiita.com/kurata04/items/2d3a0f803b20bd56be18#%E5%8B%95%E4%BD%9C%E7%92%B0%E5%A2%83)動作環境

今回の実践編では、以下の環境を使用します。

-   Visual Studio Code
-   GitHub Copilot
-   Docker(なくても実行可能)

一部のMCPサーバーでは Python や Node.js などが必要になる場合がありますが、必要になったタイミングで適宜インストールしてください。

本記事ではVisual Studio Code および GitHub Copilot の導入・連携が済んでいることを前提としています。

## [](https://qiita.com/kurata04/items/2d3a0f803b20bd56be18#mcp%E3%81%AE%E4%BD%BF%E3%81%84%E6%96%B9)MCPの使い方

### [](https://qiita.com/kurata04/items/2d3a0f803b20bd56be18#mcp%E3%81%AE%E6%9C%89%E5%8A%B9%E5%8C%96)MCPの有効化

まずはVSCodeでMCPを有効化します。

1.  VSCodeの設定を開く(Mac: `Cmd + ,`, Windows: `Ctrl + ,`)
    
2.  検索バーに「mcp」と入力  
    [![MCPの有効化](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F4acfe995-86a5-45f9-9879-ef2e86267391.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=56a206a5ed46030be012efb7b643dc87)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F4acfe995-86a5-45f9-9879-ef2e86267391.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=56a206a5ed46030be012efb7b643dc87)
    
3.  2の画面で「settings.jsonを編集」をクリックする  
    ※ワークスペースのみに適用したい場合は「ワークスペース」をクリックしてから「settings.jsonを編集」をクリック  
    `settings.json`に以下の設定が追加されます
    
    ```
    "mcp": {
      "inputs": [],
      "servers": {
        "mcp-server-time": {
          "command": "python",
          "args": [
            "-m",
            "mcp_server_time",
            "--local-timezone=America/Los_Angeles"
          ],
          "env": {}
        }
      }
    }
    ```
    

これらの設定で[時刻とタイムゾーンの変換機能を提供するMCPサーバー](https://github.com/modelcontextprotocol/servers/blob/main/src/time/src/mcp_server_time/server.py)を使えるようになります。

### [](https://qiita.com/kurata04/items/2d3a0f803b20bd56be18#mcp%E3%81%AE%E5%88%A9%E7%94%A8)MCPの利用

実際に利用してみます。[MCPの有効化](https://qiita.com/kurata04/items/2d3a0f803b20bd56be18#mcp%E3%81%AE%E6%9C%89%E5%8A%B9%E5%8C%96)が完了したら、以下の手順でMCPを利用できます。

1.  GitHub Copilot Chatを開いてAgentモードに切り替える
    
    [![Agentモードへの切り替え](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F951bee1e-1319-48dd-942c-66214fa97803.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=8d267dd2d8848a63cebf9f0688c02c80)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F951bee1e-1319-48dd-942c-66214fa97803.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=8d267dd2d8848a63cebf9f0688c02c80)
    
2.  青いリロードボタンが出たらクリックする
    
    [![リロードボタンのクリック](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F881992a4-2c88-460a-9334-e17347372480.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=9e5d69d900a140cc34e8de01515bee59)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F881992a4-2c88-460a-9334-e17347372480.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=9e5d69d900a140cc34e8de01515bee59)
    
3.  Copilotで質問する
    
    `mcp_server_time`を使う場合は事前にインストールが必要です。
    
    ```
    pip install mcp-server-time
    ```
    
    `mcp_server_time`を使えそうな質問を投げてみます(例: 「東京時間午前9時30分をニューヨーク時間に変換して」)  
    途中で実行許可を求められた場合は許可を与えます。常に許可やこのセッションのみなどの設定も可能です。
    
    [![convert_timeの実行許可](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2Fc9fe1b82-4c11-4dc6-b571-99da300ed373.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=ecb4b7f95855f4cf500211ee89ceb480)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2Fc9fe1b82-4c11-4dc6-b571-99da300ed373.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=ecb4b7f95855f4cf500211ee89ceb480)
    
    MCPサーバを利用して時刻の変換ができました。
    
    [![時刻変換結果](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F3c57f549-3d05-48a2-9dad-110041b79ab9.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=adbbe1a3648b4474cfada6bb416a33c3)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F3c57f549-3d05-48a2-9dad-110041b79ab9.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=adbbe1a3648b4474cfada6bb416a33c3)
    

チャット欄左下のスパナマークをクリックすることで、エージェントが利用できる機能を確認・選択でき、MCPのツールもここに表示されます。  
使いたくない機能はチェックマークを外すことで無効にできます。

[![ツールを選択する](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F1e4d25bc-e228-4ef5-b8a9-5d76a9e24635.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=de35e3c237abdfe6b44d8cca2c30fc5f)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F1e4d25bc-e228-4ef5-b8a9-5d76a9e24635.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=de35e3c237abdfe6b44d8cca2c30fc5f)

[![ツール一覧](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F51274d7b-4417-4784-aad2-a63a147f530f.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=7355b2d8b4e99531b6755d08656795ee)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F51274d7b-4417-4784-aad2-a63a147f530f.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=7355b2d8b4e99531b6755d08656795ee)

時間変換に利用できる`convert_time`を無効にした状態で時間変換をお願いしてみると`get_current_time`だけを利用して変換するようになりました。  
[![convert_time無効.png](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2Fdb5df3ec-3a9f-44d9-a761-65a3a389b529.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=50b5bf8def3e3561bafe199547088f5d)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2Fdb5df3ec-3a9f-44d9-a761-65a3a389b529.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=50b5bf8def3e3561bafe199547088f5d)

### [](https://qiita.com/kurata04/items/2d3a0f803b20bd56be18#mcp%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC%E3%81%AE%E8%B5%B7%E5%8B%95)MCPサーバーの起動

コマンドを利用して、サーバーへの操作(起動、停止、出力表示、構成表示)ができます。  
サーバーが起動していない場合はここから起動します。

1.  コマンドパレットを開く(Mac: `Cmd + Shift + P`, Windows: `Ctrl + Shift + P`)
    
2.  `MCP: List Servers`を選択
    
    [![MCPサーバーの一覧表示](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2Fa779daba-6950-46f8-970e-a415b0a5cd25.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=bcfa2ebd26116d696f6c2ae7c64ccf2b)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2Fa779daba-6950-46f8-970e-a415b0a5cd25.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=bcfa2ebd26116d696f6c2ae7c64ccf2b)
    
3.  操作を行いたいサーバーを選択
    
    [![MCPサーバーの選択](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F8eda9601-0cc8-4cdc-b189-5e24ee5b8b48.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=144b045e890c0eb7ab16032979e56601)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F8eda9601-0cc8-4cdc-b189-5e24ee5b8b48.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=144b045e890c0eb7ab16032979e56601)
    
4.  行いたい操作を選択する
    
    [![サーバーアクション](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2Fa8fad800-61ff-4275-b8b5-0e63349dd6a5.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=b71803bf8f73c1d7b009a7c671753cb3)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2Fa8fad800-61ff-4275-b8b5-0e63349dd6a5.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=b71803bf8f73c1d7b009a7c671753cb3)
    

## [](https://qiita.com/kurata04/items/2d3a0f803b20bd56be18#%E5%A4%96%E9%83%A8%E3%82%B5%E3%83%BC%E3%83%93%E3%82%B9%E3%81%A8%E3%81%AE%E9%80%A3%E6%90%BA)外部サービスとの連携

`mcp_server_time`のようにローカルで動かすタイプのMCPサーバーもあれば、設定だけで外部サービスと連携できるものもあります。  
利用できるサービスについては[MCPのドキュメント](https://github.com/modelcontextprotocol/servers?tab=readme-ov-file#-third-party-servers)を参照してください。  
いくつかのサービスを実際に使ってみましょう。

利用できるツールが多すぎると一部のツールを認識できないようです。  
エラーは出ないのに目的のツールが実行されない場合はツールを整理してみてください。

### [](https://qiita.com/kurata04/items/2d3a0f803b20bd56be18#github%E3%81%A8%E3%81%AE%E9%80%A3%E6%90%BA)GitHubとの連携

リポジトリやIssueを作成する、プルリクエストをマージするなどGitHubの様々な操作が可能です。  
「GitHub MCP」などで検索すると`@modelcontextprotocol/server-github`が見つかりますが、こちらは`modelcontextprotocol`リポジトリ内の参考実装で現在はアーカイブ済です。  
GitHub公式提供のMCPサーバーが利用可能なので、そちらを使うのが良いでしょう。

---

今回はDockerを利用してGitHub MCPサーバーを起動します。試す場合はDockerを起動しておいてください。  
Dockerを使わない場合の設定方法は[こちら](https://github.com/github/github-mcp-server?tab=readme-ov-file#build-from-source)を参照してください。

利用にはGitHubのAPIトークンが必要です。用途に合わせてAPIに必要な権限を設定します。  
今回は`Fine-grained`でトークンを作成して、お試し用に作成したリポジトリを指定して以下の権限を付与しています。

-   Contents: Read and Write
-   Issues: Read and Write
-   Pull requests: Read and Write

APIトークンの取得方法

1.  [GitHub](https://github.com/)にログイン
2.  右上のプロフィールアイコンをクリックし、「[Settings](https://github.com/settings/profile)」を選択
3.  サイドメニューから「[Developer settings](https://github.com/settings/apps)」を選択
4.  サイドメニューから「Personal access tokens」を展開
5.  「[Fine-grained tokens](https://github.com/settings/personal-access-tokens)」「[Tokens (classic)](https://github.com/settings/tokens)」のどちらかを選択
6.  「Generate new token」をクリック

`settings.json`に以下の設定を追加します。`inputs`を入れる場所に注意してください。

```
{
  "mcp": {
    "inputs": [
      {
        "type": "promptString",
        "id": "github_token",
        "description": "GitHub Personal Access Token",
        "password": true
      }
    ],
    "servers": {
      "github": {
        "command": "docker",
        "args": [
          "run",
          "-i",
          "--rm",
          "-e",
          "GITHUB_PERSONAL_ACCESS_TOKEN",
          "ghcr.io/github/github-mcp-server"
        ],
        "env": {
          "GITHUB_PERSONAL_ACCESS_TOKEN": "${input:github_token}"
        }
      }
    }
  }
}
```

`mcp-server-time`の設定がある場合は、以下のようになります。サーバーの設定は`servers`の中に追加していきます。

```
{
  "mcp": {
    "inputs": [
      {
        "type": "promptString",
        "id": "github_token",
        "description": "GitHub Personal Access Token",
        "password": true
      }
    ],
    "servers": {
      "mcp-server-time": {
        "command": "python",
        "args": [
          "-m",
          "mcp_server_time",
          "--local-timezone=America/Los_Angeles"
        ],
        "env": {}
      },
      "github": {
        "command": "docker",
        "args": [
          "run",
          "-i",
          "--rm",
          "-e",
          "GITHUB_PERSONAL_ACCESS_TOKEN",
          "ghcr.io/github/github-mcp-server"
        ],
        "env": {
          "GITHUB_PERSONAL_ACCESS_TOKEN": "${input:github_token}"
        }
      }
    }
  }
}
```

`MCP: List Servers`から"github"を選択し、サーバーを起動します。  
この時にGitHubのAPIトークンを入力するよう求められるので、発行したトークンを入力しましょう。

試しにissueの追加を依頼してみます。

[![issue作成](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2Fccce5b10-c865-4947-8b1e-e888695e852e.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=0122f0bc62b1d9d3f933250d109d56e4)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2Fccce5b10-c865-4947-8b1e-e888695e852e.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=0122f0bc62b1d9d3f933250d109d56e4)

[![作成したissue](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F8953d819-dcda-4512-86dd-ce893654b365.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=e77dd6ec92738c3e7e73829eb97b2deb)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F8953d819-dcda-4512-86dd-ce893654b365.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=e77dd6ec92738c3e7e73829eb97b2deb)

ざっくりとした指示しか与えていませんでしたがプロンプトの意図を補完してかなり細かな内容まで作成してくれています。プロンプトに書いておけば指定のフォーマットでの作成も可能です。

同じようにプルリクエストの作成などもできるので、  
issueを作る → issueを参照する → issue内容をコードに反映する → プルリクエストを作成する  
という流れを全てCopilotに任せることも可能です。

### [](https://qiita.com/kurata04/items/2d3a0f803b20bd56be18#aws%E3%81%A8%E3%81%AE%E9%80%A3%E6%90%BA)AWSとの連携

自然言語によるAWSドキュメントの検索やS3の操作、コスト分析などが可能です。たくさんあるので詳細は上記リポジトリを参照してください。

今回はどれくらいのコストがかかるのかをコードから分析してもらいます。  
AWS環境を構築するコードが必要なので、AWSが作成している[GenU](https://github.com/aws-samples/generative-ai-use-cases)というリポジトリをクローンしてきて参照します。

ドキュメントに記載の通りに進めます。AWS Pricing APIへのアクセス権限を持ったプロファイルが必要です。

1.  `uv`をインストールする
    
    ```
    pip install uv
    ```
    
2.  pythonをインストールする
    
    ```
    uv python install 3.10
    ```
    
3.  `settings.json`に以下の設定を追加する
    
    `AWS_PROFILE`は各自の環境に合わせて設定してください。  
    ※[ドキュメント](https://awslabs.github.io/mcp/servers/cost-analysis-mcp-server/)には`disabled`と`autoApprove`が設定されていますがエラーになったため削除しています。
    
    ```
    "awslabs.cost-analysis-mcp-server": {
      "command": "uvx",
      "args": ["awslabs.cost-analysis-mcp-server@latest"],
      "env": {
          "FASTMCP_LOG_LEVEL": "ERROR",
          "AWS_PROFILE": "your-aws-profile"
      },
    }
    ```
    

GenUのコードに対してコスト分析を試してみます。  
「このプロジェクトで」のように質問することでコードからタイムアウトなどの設定を取得し、それを基にコストを分析してくれます。

[![コスト分析結果1](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F7d65e017-be48-468c-9a9a-ffd207352d09.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=0919e5ef9e2dd4a70851d28956b71776)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F7d65e017-be48-468c-9a9a-ffd207352d09.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=0919e5ef9e2dd4a70851d28956b71776)

[![コスト分析結果2](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F14572905-b822-4964-8424-6170d32229c7.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=de18192004d4f3cf38acb90c74a2955e)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F14572905-b822-4964-8424-6170d32229c7.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=de18192004d4f3cf38acb90c74a2955e)

GenUは[概算料金](https://aws.amazon.com/jp/cdp/ai-chatbot/)を出しており、そこでは$0.64として試算されています。  
前提条件を提示していなかったのもあり多少のズレは出ますが同じような値が出ていることがわかります。  
必要に応じてプロンプトで利用想定を渡しましょう。

### [](https://qiita.com/kurata04/items/2d3a0f803b20bd56be18#backlog%E3%81%A8%E3%81%AE%E9%80%A3%E6%90%BA)Backlogとの連携

主な機能は以下の通りです。利用にはAPIキーが必要です。

-   プロジェクトツール（作成、読み取り、更新、削除）
-   課題とコメントの追跡（作成、更新、削除、一覧表示）
-   Wikiページサポート
-   Gitリポジトリとプルリクエストツール
-   通知ツール
-   最適化されたレスポンスのためのGraphQLスタイルのフィールド選択
-   大規模なレスポンスに対するトークン制限

([ヌーラボブログ](https://nulab.com/ja/blog/backlog/released-backlog-mcp-server/)より)

Backlog APIキーの取得方法

1.  [Backlog](https://backlog.com/)にログイン
2.  右上のプロフィールアイコンをクリックし、「個人設定」を選択
3.  左側のメニューから「API」を選択
4.  「メモ」を入力して「登録」ボタンをクリック

---

GitHubと同じくDockerを使用した方法で試します。`settings.json`に以下の設定を追加します。  
Dockerを使わない場合の設定方法は[こちら](https://github.com/nulab/backlog-mcp-server/blob/main/README.ja.md#%E3%82%AA%E3%83%97%E3%82%B7%E3%83%A7%E3%83%B32-%E6%89%8B%E5%8B%95%E3%82%BB%E3%83%83%E3%83%88%E3%82%A2%E3%83%83%E3%83%97-nodejs)を参照してください。

`your-domain.backlog.com`を実際のBacklogドメインに、`your-api-key`を実際のBacklog APIキーに置き換えてください。

BacklogドメインはURLの`https://`の後ろにある部分です。例えば、`https://your-domain.backlog.com`であれば`your-domain.backlog.com`がドメインになります。

```
"backlog": {
  "command": "docker",
  "args": [
    "run",
    "--pull", "always",
    "-i",
    "--rm",
    "-e", "BACKLOG_DOMAIN",
    "-e", "BACKLOG_API_KEY",
    "ghcr.io/nulab/backlog-mcp-server"
  ],
  "env": {
    "BACKLOG_DOMAIN": "your-domain.backlog.com",
    "BACKLOG_API_KEY": "your-api-key"
  }
}
```

ツールが多すぎると認識しない、という話を記事上部でしましたが、私の環境ではGitHubとBacklogの両方を入れた場合に起こりました。  
同じ現象になった方は、一度GitHubサーバーの設定を削除してBacklogサーバーを再起動してからお試しください。

試しにタスクを確認してもらいましょう。

[![直近タスクの確認](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F5c3fb926-81f8-4a11-9fd8-562dad826963.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=ee40efdad416d49a03b2dd1a58fca122)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F5c3fb926-81f8-4a11-9fd8-562dad826963.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=ee40efdad416d49a03b2dd1a58fca122)

実際のタスク内容はお見せできませんが、確認すると過不足なく拾えているようでした。

### [](https://qiita.com/kurata04/items/2d3a0f803b20bd56be18#figma%E3%81%A8%E3%81%AE%E9%80%A3%E6%90%BA)Figmaとの連携

Figmaのデザインを参照してコードを生成することができます。  
こちらも利用にはAPIトークンが必要です。用途に合わせてAPIに必要な権限を設定します。

APIトークンの取得方法

1.  [Figma](https://www.figma.com/)にログイン
    
2.  右上のプロフィールアイコンをクリックし、「設定」を選択
    
3.  「セキュリティ」タブを開く
    
4.  「新規トークンを発行」をクリック
    

---

`settings.json`に以下の設定を追加します。`YOUR-KEY`には発行したトークンを入力してください。

```
"Framelink Figma MCP": {
  "command": "npx",
  "args": ["-y", "figma-developer-mcp", "--figma-api-key=YOUR-KEY", "--stdio"]
}
```

元になるデザインが必要なのであらかじめ用意しておきます。今回はデザインテンプレートをお借りしました(お借りしたのは[こちら](https://www.figma.com/community/file/872144934711314532/login-page-design))。  
もちろん自分で作成したデザインも利用可能です。  
ファイルサイズが大きすぎるとタイムアウトになる場合があります。動かない場合には一度軽いファイルなどで試してみてください。

ファイルを参照してもらうにはURLを渡します。

[![画面作成依頼](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F5591f7ae-f91f-41a8-913b-fda03e45d657.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=4ce204b3f1fad7e3f04541b606e9df29)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F5591f7ae-f91f-41a8-913b-fda03e45d657.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=4ce204b3f1fad7e3f04541b606e9df29)

出来上がったのが以下のページです。

[![作成された画面](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F914f5218-857f-4851-a4f1-70224252afbb.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=068a42ce4b5307ab113f0bd32d209ddf)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F914f5218-857f-4851-a4f1-70224252afbb.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=068a42ce4b5307ab113f0bd32d209ddf)

カートアイコンの再現は難しかったようですがフォントや色、ボタンの配置などはほぼ完璧に再現できました。背景模様も全く一緒とまではいきませんが寄せようとはされています。  
特に指定していませんでしたが、ログインボタンにはホバー時のアニメーションも設定されています。

## [](https://qiita.com/kurata04/items/2d3a0f803b20bd56be18#%E8%87%AA%E5%88%86%E3%81%A7mcp%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC%E3%82%92%E4%BD%9C%E6%88%90%E3%81%99%E3%82%8B)自分でMCPサーバーを作成する

ここまで紹介してきた例ではサービス側で用意されたMCPサーバーを利用していましたが、使いたいサービスのMCPサーバーが公開されているとは限りません。  
そういった場合には自分でMCPサーバーを作成して利用することも可能です。  
試しにサイコロを振った結果を返すMCPサーバーを作成してみます。  
コードはClaudeを使って作成しました。

### [](https://qiita.com/kurata04/items/2d3a0f803b20bd56be18#mcp%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC%E3%81%AE%E4%BD%9C%E6%88%90)MCPサーバーの作成

今回はTypeScriptでMCPサーバーを作成します。Pythonなどの別言語でも作成可能です。

必要なパッケージをインストールします。

```
npm install  @modelcontextprotocol/sdk zod
```

以下の内容で`app.ts`ファイルを作成します。ファイル名は任意です。  
コードが長いので折りたたみます。

app.tsの内容

```
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

// サイコロを振る関数
function rollDice(sides: number): number {
  return Math.floor(Math.random() * sides) + 1;
}

// Create an MCP server
const server = new McpServer({
  name: "DiceRoller",
  version: "1.0.0"
});

// 1. シンプルなサイコロを振るツール
server.tool("rollSimpleDice",
  {
    sides: z.number().describe("サイコロの面数"),
    count: z.number().describe("振るサイコロの個数")
  },
  async ({ sides, count }) => {
    try {
      // サイコロを指定回数振る
      const results: number[] = [];
      for (let i = 0; i < count; i++) {
        results.push(rollDice(sides));
      }

      // 合計値を計算
      const sum = results.reduce((acc, val) => acc + val, 0);

      return {
        content: [{
          type: "text",
          text: `${results.join(", ")}（合計: ${sum}）`
        }]
      };
    } catch (error) {
      return {
        content: [{ type: "text", text: `エラーが発生しました: ${error.message}` }]
      };
    }
  }
);

// 2. 目標値に対してサイコロを振るツール
server.tool("rollAgainstTarget",
  {
    sides: z.number().describe("サイコロの面数"),
    count: z.number().describe("振るサイコロの個数"),
    target: z.number().describe("成功とみなす最小値")
  },
  async ({ sides, count, target }) => {
    try {
      if (target > sides) {
        return {
          content: [{ type: "text", text: `目標値${target}は${sides}面サイコロでは達成不可能です。` }]
        };
      }

      // サイコロを振る
      const results: number[] = [];
      for (let i = 0; i < count; i++) {
        results.push(rollDice(sides));
      }

      // 判定
      const success = results.some(result => result >= target);
      const resultText = count === 1 ?
        `出目: ${results[0]} → ${success ? "成功" : "失敗"}` :
        `出目: ${results.join(", ")} → ${success ? "成功" : "失敗"}`;

      return {
        content: [{ type: "text", text: resultText }]
      };
    } catch (error) {
      return {
        content: [{ type: "text", text: `エラーが発生しました: ${error.message}` }]
      };
    }
  }
);

// Start receiving messages on stdin and sending messages on stdout
const transport = new StdioServerTransport();
await server.connect(transport);

```

軽くコードの説明をすると、以下のような処理をしています。

-   `new McpServer()`  
    MCPサーバーを初期化します。`name`と`version`は任意の値を設定します
-   `server.tool()`  
    LLMが呼び出すツールを定義します。今回であればサイコロを振った結果を返却するツールを定義しています
-   `server.connect()`  
    標準入力からメッセージを受け取り、標準出力にメッセージを送信します

他のMCPサーバーと同じように`settings.json`に設定を追加します。`args`には作成した`app.ts`のパスを指定してください。

```
"DiceRoller": {
    "command": "node",
    "args": ["/your/path/to/app.ts"]
}
```

これでLLMは会話からサイコロの振り方を判断し、結果を返せるようになります。

[![複数サイコロを振る](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F97029279-cfcc-406e-b86b-6858c45fbe7d.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=21b95beb1df8a28ca1cf5057d054deef)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F97029279-cfcc-406e-b86b-6858c45fbe7d.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=21b95beb1df8a28ca1cf5057d054deef)

[![サイコロの出目が目標値を超えるかを判定する](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F685bf02e-8903-4192-bbd5-f2721044c931.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=d991aa4cb21938cfb7fbc9793808d5d4)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F1954468%2F685bf02e-8903-4192-bbd5-f2721044c931.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=d991aa4cb21938cfb7fbc9793808d5d4)

このように、APIを利用したMCPサーバーを自分で用意することが可能です。

## [](https://qiita.com/kurata04/items/2d3a0f803b20bd56be18#%E3%81%BE%E3%81%A8%E3%82%81)まとめ

「AIが勝手にやってくれたら楽なのに」が少しだけ現実に近づくのがMCPのいいところです。  
公式のサーバーもいろいろ用意されていて、導入するのも`settings.json`の編集くらいで済むので思ったより手軽でした。  
興味が湧いた方はぜひご自身でも試してみてください。

7

X（Twitter）でシェアする

Facebookでシェアする

[](https://b.hatena.ne.jp/entry/s/qiita.com/kurata04/items/2d3a0f803b20bd56be18)

はてなブックマークに追加する
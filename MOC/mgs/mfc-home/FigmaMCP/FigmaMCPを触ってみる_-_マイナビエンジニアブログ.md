# FigmaMCPを触ってみる | マイナビエンジニアブログ

## はじめに

今話題のMCPですが、WebデザインやUIデザイン向けツールのFigmaでもMCPが公開されました。

本記事では、下記をメイン書いています

-   FigmaMCPを利用できるまで
-   簡単チュートリアル

## [](https://mynavi.docbase.io/posts/3774503#mcp%E3%81%A8%E3%81%AF)MCPとは

AIモデルと外部サービス（システム）を連携するための「共通ルール（プロトコル）」です。  
各社がこのルールに沿った「AI専用コントローラー（MCPサーバー）」を提供し、AIアプリ開発者（MCPクライアント）はそれを呼び出すだけで各種サービスと連携可能になります。  

これにより、様々なサービスをAIエージェントで操作できるようになります。

## [](https://mynavi.docbase.io/posts/3774503#figmamcp%E3%81%A8%E3%81%AF)FigmaMCPとは

AI が Figma のデザインデータに直接アクセスし、そのデータを理解・操作することができるようになります。

実際に、Figmaはこの辺りを参照するようです。

-   デザイン情報 (色・フォント・サイズ・間隔 etc..)
-   コンポーネント間の関係
-   Figma内のコメント

この辺りが参照できると今までできなかった下記タスクもAIにお願いできるようになりそうです。

-   Figmaのデザインをより忠実に再現
-   レスポンシブ対応
-   コンポーネント関係の解釈

([参考 Figma MCPとは？何ができるの？](https://zenn.dev/takna/articles/mcp-server-tutorial-06-figma))

## [](https://mynavi.docbase.io/posts/3774503#%E5%88%A9%E7%94%A8%E3%81%A7%E3%81%8D%E3%82%8B%E3%81%BE%E3%81%A7%E3%81%AE%E4%BD%9C%E6%A5%AD)利用できるまでの作業

本手順は、github copilot でFigmaMCPを導入する手順です。

### [](https://mynavi.docbase.io/posts/3774503#%E2%91%A0%E5%80%8B%E4%BA%BA%E3%81%AE%E3%82%A2%E3%82%AB%E3%82%A6%E3%83%B3%E3%83%88%E3%81%A7figma%E3%81%AEaccount-settings%E3%82%92%E9%96%8B%E3%81%8F)①個人のアカウントでFigmaのAccount settingsを開く

![](https://engineerblog.mynavi.jp/uploads/409d31b8-ebe9-46ad-a49d-d4d53ae45768-1280x1280r.png)

### [](https://mynavi.docbase.io/posts/3774503#%E2%91%A1%E3%83%88%E3%83%BC%E3%82%AF%E3%83%B3%E7%99%BA%E8%A1%8C)②トークン発行

security>Personal access tokens>Generate new token  
[](https://image.docbase.io/uploads/0c5f6e3c-403d-48dc-a5c3-29f3270496a5.png)

![](https://engineerblog.mynavi.jp/uploads/0c5f6e3c-403d-48dc-a5c3-29f3270496a5.png)

token名を入力 → File content を read-only にする → Generate token  
[](https://image.docbase.io/uploads/f8d0dfb9-fc65-4b6e-b8c2-6d9cf5b496b6.png)

![](https://engineerblog.mynavi.jp/uploads/f8d0dfb9-fc65-4b6e-b8c2-6d9cf5b496b6.png)

### [](https://mynavi.docbase.io/posts/3774503#%E2%91%A2mcp%E3%81%AE%E8%A8%AD%E5%AE%9A%E3%82%92vscode%E3%81%A7%E8%A1%8C%E3%81%86)③MCPの設定をvscodeで行う

vscodeの設定用のjsonを修正します。  
mcp.servers の中に下記の設定を追記します。

```
  "mcp": {
    "inputs": [],
    "servers": {
      "figma-developer-mcp": {
        "command": "npx",
        "args": [
          "-y",
          "figma-developer-mcp",
          "--figma-api-key=${③のトークン}",
          "--stdio"
        ]
      }
    }
```

### [](https://mynavi.docbase.io/posts/3774503#%E2%91%A3vscode-%E3%81%AE-github-copilot%E3%81%AE%E3%82%A8%E3%83%BC%E3%82%B8%E3%82%A7%E3%83%B3%E3%83%88%E3%83%A2%E3%83%BC%E3%83%89%E3%82%92%E6%9C%89%E5%8A%B9%E3%81%AB%E3%81%99%E3%82%8B)④vscode の github copilotのエージェントモードを有効にする

vscodeの設定から chat > Agent: Enabled を有効にする  
(出てこない場合は、アップデート&再起動をする)  
[](https://image.docbase.io/uploads/19793f1f-8971-4980-a796-865c1908f48e.png)

![](https://engineerblog.mynavi.jp/uploads/19793f1f-8971-4980-a796-865c1908f48e.png)

### [](https://mynavi.docbase.io/posts/3774503#%E2%91%A4github-copilot%E3%82%92%E3%82%A8%E3%83%BC%E3%82%B8%E3%82%A7%E3%83%B3%E3%83%88%E3%83%A2%E3%83%BC%E3%83%89%E3%81%AB%E5%A4%89%E6%9B%B4%E3%81%99%E3%82%8B)⑤github copilotをエージェントモードに変更する

github copilotのチャットを開き、エージェントモードに変更する  
[](https://image.docbase.io/uploads/8162f8dc-f90d-4322-99da-d3623335c30b.png)

![](https://engineerblog.mynavi.jp/uploads/8162f8dc-f90d-4322-99da-d3623335c30b.png)

以上です！これで利用できるようになります。

## [](https://mynavi.docbase.io/posts/3774503#%E8%A9%A6%E3%81%97%E3%81%AB%E3%82%B3%E3%83%B3%E3%83%9D%E3%83%BC%E3%83%8D%E3%83%B3%E3%83%88%E3%82%92%E5%87%BA%E5%8A%9B%E3%81%97%E3%81%A6%E3%82%82%E3%82%89%E3%81%86)試しにコンポーネントを出力してもらう

今回は、簡単なカードコンポーネントを出力してもらいます。  
[](https://image.docbase.io/uploads/d7bb7974-1c9c-4666-8f82-eee6ca171084.png)

![](https://engineerblog.mynavi.jp/uploads/d7bb7974-1c9c-4666-8f82-eee6ca171084.png)

### [](https://mynavi.docbase.io/posts/3774503#%E2%91%A0figma%E3%81%8B%E3%82%89%E3%83%95%E3%83%AC%E3%83%BC%E3%83%A0%E3%81%AEurl%E3%82%92%E5%8F%96%E5%BE%97%E3%81%97%E3%81%BE%E3%81%99)①FigmaからフレームのURLを取得します。

該当フレームを選択しながら、右上のシェアボタンを教えて、コピーします。

### [](https://mynavi.docbase.io/posts/3774503#%E2%91%A1%E5%AE%9F%E9%9A%9B%E3%81%AB%E6%9B%B8%E3%81%84%E3%81%A6%E3%81%A6%E3%82%82%E3%82%89%E3%81%86)②実際に書いててもらう

今回はこんなプロンプトで指示してみました

```
figmaを参照して、カードコンポーネントを作成してください

・外部からプロップスを渡せるようにしてください。
・tailwindで実装してください
・セマンティックなHTMLを心がけてください。

card component:
https://www.figma.com/design/....
```

Figmaを参照するか聞かれますが、続行してください。  
[](https://image.docbase.io/uploads/a217ab94-3556-489b-a09e-b54aeddf4e27.png)

![](https://engineerblog.mynavi.jp/uploads/a217ab94-3556-489b-a09e-b54aeddf4e27.png)

### [](https://mynavi.docbase.io/posts/3774503#%E6%B0%97%E3%81%AB%E3%81%AA%E3%82%8B%E5%87%BA%E5%8A%9B%E7%B5%90%E6%9E%9C%E3%81%AF)気になる出力結果は...

かなり高クオリティーです... !  
タグの絶対配置の部分だけ設定されていませんね (出力している感じ、絶対配置はあまり得意でないように見えます)  
[](https://image.docbase.io/uploads/590b8c13-81d8-46e2-ab81-075fc84cd56f.png)

![](https://engineerblog.mynavi.jp/uploads/590b8c13-81d8-46e2-ab81-075fc84cd56f-1280x1280r.png)

コードベースで見るとこんな感じです。  
プロップスも想定通り渡せるようになっていたり、HTMLタグの使い分けもいい感じにできていて、ほぼ期待通りの実装に見えます。

```
import type { FC } from 'react';


interface CardProps {
 image: string;
 tags: string[];
 title: string;
 description: string;
 onClickDetail: () => void;
}


export const Card: FC<CardProps> = ({
 image,
 tags,
 title,
 description,
 onClickDetail,
}) => {
 return (
   <article className="flex flex-col bg-white border border-[rgba(17,17,17,0.1)] rounded-2xl overflow-hidden">
     <div className="relative aspect-video">
       <img
         src={image}
         alt=""
         className="w-full h-full object-cover"
       />
     </div>
    
     <div className="flex flex-col justify-between p-6 flex-1">
       <div className="space-y-4">
         <div className="flex gap-2.5 flex-wrap">
           {tags.map((tag, index) => (
             <span
               key={index}
               className="px-4 py-3 text-sm font-bold text-[#111111] border-2 border-[rgba(17,17,17,0.1)] rounded-full"
             >
               {tag}
             </span>
           ))}
         </div>
        
         <div className="space-y-2">
           <h3 className="text-lg font-bold text-[#111111] leading-[1.3]">
             {title}
           </h3>
           <p className="text-base text-[#111111] leading-6">
             {description}
           </p>
         </div>
       </div>


       <button
         onClick={onClickDetail}
         className="w-full mt-4 px-6 py-4 text-sm font-bold text-[#111111] border-2 border-[rgba(17,17,17,0.1)] rounded-xl"
       >
         詳しくみる
       </button>
     </div>
   </article>
 );
};
```

## [](https://mynavi.docbase.io/posts/3774503#%E3%81%BE%E3%81%A8%E3%82%81)まとめ

今のところの感想としては、LovableやReplitの各種AIツール や Figma to Codeなどのコード生成系のFigmaプラグイン と比較して、精度がはるかに高いように見えます...！

今回は、FigmaMCPの使い方 + チュートリアルをやってみましたが、次回はもう少し高難易度の出力や、他ツールとの比較とかもやってみようと思います！

※本記事は2025年05月時点の情報です。
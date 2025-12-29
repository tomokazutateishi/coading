document.addEventListener('DOMContentLoaded', () => {
  const urlsTextarea = document.getElementById('urls');
  const openButton = document.getElementById('openUrls');
  const statusDiv = document.getElementById('status');

  // URLを正規化する関数（http://またはhttps://がない場合は追加）
  function normalizeUrl(url) {
    url = url.trim();
    if (!url) return null;
    
    // 既にhttp://またはhttps://で始まっている場合はそのまま
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    
    // それ以外の場合はhttps://を追加
    return 'https://' + url;
  }

  // URLが有効かどうかをチェックする関数
  function isValidUrl(url) {
    try {
      const urlObj = new URL(url);
      return urlObj.protocol === 'http:' || urlObj.protocol === 'https:';
    } catch (e) {
      return false;
    }
  }

  // ステータスメッセージを表示
  function showStatus(message, isError = false) {
    statusDiv.textContent = message;
    statusDiv.className = isError ? 'text-red-600' : 'text-green-600';
    statusDiv.classList.remove('hidden');
    
    setTimeout(() => {
      statusDiv.classList.add('hidden');
    }, 3000);
  }

  // URLを開く
  openButton.addEventListener('click', async () => {
    const urlsText = urlsTextarea.value;
    
    if (!urlsText.trim()) {
      showStatus('URLを入力してください', true);
      return;
    }

    // 改行・スペース区切りで分割し、空行を除去
    const parts = urlsText
      .split(/\s+/)
      .map(p => p.trim())
      .filter(Boolean);
    // 重複を除去
    const uniqueParts = Array.from(new Set(parts));
    const validUrls = [];

    // 各行を処理
    for (const part of uniqueParts) {
      const normalizedUrl = normalizeUrl(part);
      if (normalizedUrl && isValidUrl(normalizedUrl)) {
        validUrls.push(normalizedUrl);
      }
    }

    if (validUrls.length === 0) {
      showStatus('有効なURLが見つかりませんでした', true);
      return;
    }

    // すべてのURLを新しいタブで開く（ユーザー操作のジェスチャーを保持するため即時実行）
    const results = await Promise.allSettled(
      validUrls.map(url =>
        chrome.tabs.create({ url }).catch(err => {
          // 念のため catch しておく
          throw err;
        })
      )
    );

    const successCount = results.filter(r => r.status === 'fulfilled').length;
    const errorCount = results.length - successCount;

    if (successCount > 0) {
      showStatus(`${successCount}個のURLを開きました${errorCount ? `（${errorCount}個失敗）` : ''}`);
      urlsTextarea.value = '';
    } else {
      showStatus('URLを開けませんでした', true);
    }
  });

  // Enterキーで開く（Ctrl+EnterまたはCmd+Enter）
  urlsTextarea.addEventListener('keydown', (e) => {
    if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
      openButton.click();
    }
  });
});


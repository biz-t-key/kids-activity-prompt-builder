<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>子供アクティビティプロンプトビルダー</title>
</head>
<body>
<style>
  :root {
    --paper: #FAF6EE; --ink: #23324B; --ink-soft: #5B6B85;
    --sun: #F4B942; --sun-deep: #C98A1A; --teal: #2A9D8F;
    --line: #E4DCC8; --card: #FFFFFF;
  }
  * { box-sizing: border-box; }
  body { margin: 0; background: var(--paper); color: var(--ink);
    font-family: "Hiragino Sans","Yu Gothic","Segoe UI",sans-serif; line-height: 1.6; }
  .wrap { max-width: 760px; margin: 0 auto; padding: 32px 20px 90px; }
  .masthead { display: flex; align-items: baseline; justify-content: space-between;
    border-bottom: 3px solid var(--ink); padding-bottom: 14px; margin-bottom: 28px; }
  .masthead h1 { font-size: 22px; letter-spacing: .02em; margin: 0; font-weight: 800; }
  .masthead .tag { font-size: 12px; color: var(--ink-soft); border: 1px solid var(--line);
    border-radius: 999px; padding: 4px 10px; background: var(--card); white-space: nowrap; }
  .section { background: var(--card); border: 1px solid var(--line);
    border-radius: 14px; padding: 20px 22px; margin-bottom: 16px; }
  .section h2 { font-size: 13px; color: var(--sun-deep); text-transform: uppercase;
    letter-spacing: .08em; margin: 0 0 4px; font-weight: 800; }
  .section p.hint { margin: 0 0 14px; font-size: 12.5px; color: var(--ink-soft); }
  .field { margin-bottom: 18px; }
  .field:last-child { margin-bottom: 0; }
  .field label.small { display: block; font-size: 12.5px; font-weight: 700;
    color: var(--ink); margin-bottom: 8px; }
  input[type="text"], input[type="number"] { width: 100%; padding: 9px 11px;
    border: 1.5px solid var(--line); border-radius: 8px; font-size: 14px;
    font-family: inherit; color: var(--ink); background: var(--paper); }
  input:focus { outline: 2px solid var(--teal); outline-offset: 1px; }
  .chips { display: flex; flex-wrap: wrap; gap: 8px; }
  .chip { border: 1.5px solid var(--line); background: var(--paper); color: var(--ink);
    padding: 7px 13px; border-radius: 999px; font-size: 13px; cursor: pointer;
    user-select: none; transition: all .12s ease; font-family: inherit; }
  .chip:hover { border-color: var(--teal); }
  .chip.active { background: var(--teal); border-color: var(--teal); color: #fff; font-weight: 700; }
  .chip:focus-visible { outline: 2px solid var(--ink); outline-offset: 2px; }
  .cat-grid { display: grid; grid-template-columns: 1fr; gap: 10px; }
  .cat-row { display: flex; align-items: center; justify-content: space-between;
    gap: 12px; padding: 8px 0; border-bottom: 1px dashed var(--line); }
  .cat-row:last-child { border-bottom: none; }
  .cat-name { font-size: 13.5px; font-weight: 700; flex: 1; }
  .stepper { display: flex; gap: 4px; }
  .step-btn { width: 28px; height: 28px; border-radius: 7px; border: 1.5px solid var(--line);
    background: var(--paper); color: var(--ink-soft); font-size: 12.5px; font-weight: 700; cursor: pointer; }
  .step-btn.active { background: var(--sun); border-color: var(--sun-deep); color: var(--ink); }
  .radio-row .chip.active { background: var(--sun-deep); border-color: var(--sun-deep); }
  .generate-bar { position: sticky; bottom: 14px; display: flex; justify-content: center;
    margin-top: 22px; z-index: 5; }
  .generate-btn { background: var(--ink); color: var(--paper); border: none; padding: 14px 30px;
    border-radius: 999px; font-size: 15px; font-weight: 800; cursor: pointer;
    box-shadow: 0 6px 18px rgba(35,50,75,.25); letter-spacing: .02em; }
  .generate-btn:hover { background: #1a2438; }
  .output { margin-top: 22px; border: 2px solid var(--ink); border-radius: 14px;
    overflow: hidden; display: none; }
  .output.show { display: block; }
  .output-head { background: var(--ink); color: var(--paper); padding: 10px 16px;
    display: flex; justify-content: space-between; align-items: center;
    font-size: 12.5px; font-weight: 700; letter-spacing: .04em; }
  .copy-btn { background: var(--sun); color: var(--ink); border: none; padding: 6px 14px;
    border-radius: 999px; font-size: 12.5px; font-weight: 800; cursor: pointer; }
  .copy-btn.copied { background: var(--teal); color: #fff; }
  pre#outputText { margin: 0; padding: 18px; font-family: "SF Mono",Consolas,monospace;
    font-size: 12.5px; white-space: pre-wrap; word-break: break-word;
    background: #fff; max-height: 420px; overflow-y: auto; }
  .launch { background: #fff; border-top: 1px solid var(--line); padding: 16px 18px; }
  .launch p { margin: 0 0 10px; font-size: 12px; color: var(--ink-soft); }
  .launch-btns { display: flex; flex-wrap: wrap; gap: 8px; }
  .launch-btn { flex: 1; min-width: 120px; text-align: center; text-decoration: none;
    border: 1.5px solid var(--ink); color: var(--ink); background: var(--paper);
    padding: 11px 12px; border-radius: 10px; font-size: 13px; font-weight: 800;
    cursor: pointer; transition: all .12s ease; }
  .launch-btn:hover { background: var(--ink); color: var(--paper); }
  .launch-btn.done { background: var(--teal); border-color: var(--teal); color: #fff; }
</style>

<div class="wrap">
  <div class="masthead">
    <h1>子供アクティビティ<br>プロンプトビルダー</h1>
    <span class="tag">タップして生成</span>
  </div>

  <div class="section">
    <h2>子供について</h2>
    <p class="hint">当てはまるものをタップ。複数選んでOK。空欄でも動きます。</p>

    <div class="field">
      <label class="small">年齢</label>
      <input type="number" id="age" placeholder="例: 4" min="0" max="18">
    </div>

    <div class="field">
      <label class="small">人との関わり方</label>
      <div class="chips" data-group="social">
        <button class="chip" data-val="初対面は緊張するが慣れれば打ち解ける">慣れれば打ち解ける</button>
        <button class="chip" data-val="誰とでもすぐ話せる">誰とでもすぐ話せる</button>
        <button class="chip" data-val="一人遊びが得意で長く集中できる">一人遊びが得意</button>
        <button class="chip" data-val="誰かと一緒だと安心する">誰かと一緒が安心</button>
        <button class="chip" data-val="大人数より少人数を好む">少人数を好む</button>
        <button class="chip" data-val="人混みが苦手">人混みが苦手</button>
      </div>
    </div>

    <div class="field">
      <label class="small">新しいこと・場所への反応</label>
      <div class="chips" data-group="novelty">
        <button class="chip" data-val="新しい場所や体験に慎重で、様子を見てから動く">慎重・様子見してから</button>
        <button class="chip" data-val="新しい場所や体験に積極的にとびこむ">積極的にとびこむ</button>
        <button class="chip" data-val="見通しが立つと安心して動ける">見通しがあると安心</button>
        <button class="chip" data-val="変化やサプライズを楽しめる">変化を楽しめる</button>
      </div>
    </div>

    <div class="field">
      <label class="small">集中と気質</label>
      <div class="chips" data-group="temperament">
        <button class="chip" data-val="一つのことに長く集中できる">長く集中できる</button>
        <button class="chip" data-val="興味の移り変わりが早い">飽きやすい</button>
        <button class="chip" data-val="じっくり型で自分のペースを大事にする">じっくり型</button>
        <button class="chip" data-val="活発でエネルギーが有り余っている">活発・元気</button>
        <button class="chip" data-val="感覚が敏感（音・光・肌ざわりなど）">感覚が敏感</button>
      </div>
    </div>

    <div class="field">
      <label class="small">得意な受け取り方・好きな遊び</label>
      <div class="chips" data-group="strengths">
        <button class="chip" data-val="耳から入る情報（音・言葉・歌）が得意">耳からが得意</button>
        <button class="chip" data-val="目から入る情報（映像・絵）が得意">目からが得意</button>
        <button class="chip" data-val="体を動かすことが好き">体を動かす</button>
        <button class="chip" data-val="手先を使う作業が好き">手先を使う</button>
        <button class="chip" data-val="物語・お話が好き">物語・お話</button>
        <button class="chip" data-val="音楽・リズム・歌が好き">音楽・歌</button>
        <button class="chip" data-val="絵を描くこと・工作が好き">お絵かき・工作</button>
        <button class="chip" data-val="生きものや自然が好き">生きもの・自然</button>
        <button class="chip" data-val="ごっこ遊び・見立て遊びが好き">ごっこ遊び</button>
        <button class="chip" data-val="数・図形・パズルが好き">数・パズル</button>
      </div>
    </div>

    <div class="field">
      <label class="small">避けたいこと・苦手</label>
      <div class="chips" data-group="dislikes">
        <button class="chip" data-val="勝ち負けのある競争が苦手">競争が苦手</button>
        <button class="chip" data-val="大きな音や騒がしい場所が苦手">大きな音が苦手</button>
        <button class="chip" data-val="長時間の移動が苦手">長い移動が苦手</button>
        <button class="chip" data-val="待たされる・並ぶのが苦手">待つのが苦手</button>
        <button class="chip" data-val="汚れる遊びが苦手">汚れるのが苦手</button>
        <button class="chip" data-val="初めての人に囲まれるのが苦手">初対面の集団が苦手</button>
      </div>
    </div>

    <div class="field">
      <label class="small">すでにやっている日課（重複提案を避けるため）</label>
      <div class="chips" data-group="routine">
        <button class="chip" data-val="絵本の読み聞かせ">絵本の読み聞かせ</button>
        <button class="chip" data-val="動画・映像の視聴">動画・映像視聴</button>
        <button class="chip" data-val="お絵かき・ぬりえ">お絵かき</button>
        <button class="chip" data-val="外遊び・公園">外遊び・公園</button>
        <button class="chip" data-val="習い事">習い事</button>
        <button class="chip" data-val="料理の手伝い">料理の手伝い</button>
        <button class="chip" data-val="ブロック・積み木">ブロック・積み木</button>
        <button class="chip" data-val="ごっこ遊び">ごっこ遊び</button>
      </div>
    </div>
  </div>

  <div class="section">
    <h2>条件（任意）</h2>
    <p class="hint">地域は市区町村まで入れると精度が上がります。空欄でもOK。</p>
    <div class="field">
      <label class="small">居住地（市区町村まで／任意）</label>
      <input type="text" id="location" placeholder="例: ◯◯県◯◯市（空欄可）">
    </div>
    <div class="field">
      <label class="small">動ける日</label>
      <div class="chips" data-group="workstyle">
        <button class="chip" data-val="週末のみ">週末のみ</button>
        <button class="chip" data-val="平日も動ける">平日も動ける</button>
        <button class="chip" data-val="長期休み中は毎日動ける">長期休みは毎日</button>
      </div>
    </div>
    <div class="field">
      <label class="small">予算感</label>
      <div class="chips" data-group="budget">
        <button class="chip" data-val="無料中心">無料中心</button>
        <button class="chip" data-val="1回1000円程度まで">〜1000円</button>
        <button class="chip" data-val="1回3000円程度まで">〜3000円</button>
        <button class="chip" data-val="こだわらない">こだわらない</button>
      </div>
    </div>
    <div class="field">
      <label class="small">移動手段</label>
      <div class="chips" data-group="transport">
        <button class="chip" data-val="車あり">車あり</button>
        <button class="chip" data-val="電車移動中心">電車中心</button>
        <button class="chip" data-val="徒歩圏内が理想">徒歩圏内</button>
        <button class="chip" data-val="片道30分以内">片道30分以内</button>
        <button class="chip" data-val="片道1時間程度まで可">片道1時間まで</button>
      </div>
    </div>
  </div>

  <div class="section">
    <h2>カテゴリごとの個数</h2>
    <p class="hint">最大5個まで。0にすると「不要」として扱われます。</p>
    <div class="cat-grid" id="catGrid"></div>
  </div>

  <div class="section">
    <h2>リストの性質</h2>
    <div class="field">
      <label class="small">トーン</label>
      <div class="chips radio-row" data-group="tone" data-radio="true">
        <button class="chip" data-val="日常の延長でOK">日常の延長でOK</button>
        <button class="chip" data-val="非日常・特別感を重視">非日常・特別感</button>
      </div>
    </div>
    <div class="field">
      <label class="small">対象期間</label>
      <div class="chips radio-row" data-group="period" data-radio="true">
        <button class="chip" data-val="春（3〜5月）">春</button>
        <button class="chip" data-val="夏（6〜8月）">夏</button>
        <button class="chip" data-val="秋（9〜11月）">秋</button>
        <button class="chip" data-val="冬（12〜2月）">冬</button>
        <button class="chip" data-val="夏休み期間">夏休み</button>
        <button class="chip" data-val="通年">通年</button>
      </div>
    </div>
  </div>

  <div class="generate-bar">
    <button class="generate-btn" id="genBtn">プロンプトを作る</button>
  </div>

  <div class="output" id="output">
    <div class="output-head">
      <span>生成されたプロンプト</span>
      <button class="copy-btn" id="copyBtn">コピー</button>
    </div>
    <pre id="outputText"></pre>
    <div class="launch">
      <p>プロンプトはコピー済み。ボタンで開いて貼り付け（Cmd/Ctrl+V）するだけ。</p>
      <div class="launch-btns">
        <a class="launch-btn" id="btnChatGPT" href="https://chatgpt.com/" target="_blank" rel="noopener">ChatGPTを開く</a>
        <a class="launch-btn" id="btnClaude" href="https://claude.ai/new" target="_blank" rel="noopener">Claudeを開く</a>
        <a class="launch-btn" id="btnGemini" href="https://gemini.google.com/app" target="_blank" rel="noopener">Geminiを開く</a>
      </div>
    </div>
  </div>
</div>

<script>
  const categories = ["自然・生きもの体験","運動・身体を動かす","ものづくり・工作","料理・食","文化・芸術鑑賞","学び・科学","社会体験","家でできる非日常","小旅行・特別な外出"];
  const catGrid = document.getElementById('catGrid');
  const catState = {};
  categories.forEach(cat => {
    catState[cat] = 3;
    const row = document.createElement('div');
    row.className = 'cat-row';
    row.innerHTML = '<div class="cat-name">'+cat+'</div><div class="stepper" data-cat="'+cat+'">'+[0,1,2,3,4,5].map(n=>'<button class="step-btn'+(n===3?' active':'')+'" data-n="'+n+'">'+n+'</button>').join('')+'</div>';
    catGrid.appendChild(row);
  });
  catGrid.addEventListener('click', e => {
    const btn = e.target.closest('.step-btn'); if (!btn) return;
    const stepper = btn.closest('.stepper'); const cat = stepper.getAttribute('data-cat');
    catState[cat] = parseInt(btn.getAttribute('data-n'),10);
    [...stepper.querySelectorAll('.step-btn')].forEach(b=>b.classList.remove('active'));
    btn.classList.add('active');
  });
  document.querySelectorAll('.chips').forEach(group => {
    const isRadio = group.getAttribute('data-radio') === 'true';
    group.addEventListener('click', e => {
      const chip = e.target.closest('.chip'); if (!chip) return;
      if (isRadio) { [...group.querySelectorAll('.chip')].forEach(c=>c.classList.remove('active')); chip.classList.add('active'); }
      else { chip.classList.toggle('active'); }
    });
  });
  function getSelected(g){ const group=document.querySelector('[data-group="'+g+'"]'); if(!group) return []; return [...group.querySelectorAll('.chip.active')].map(c=>c.getAttribute('data-val')); }
  function val(id){ const el=document.getElementById(id); return el?el.value.trim():''; }
  function join(g,sep){ const a=getSelected(g); return a.length?a.join(sep):''; }

  function buildPrompt(){
    const age = val('age') || '【未記入】';
    const traits = [...getSelected('social'),...getSelected('novelty'),...getSelected('temperament')];
    const personality = traits.length ? traits.join('。') : '【特にこだわりなし】';
    const strengths = join('strengths','、') || '【未記入】';
    const dislikes = join('dislikes','、') || 'なし';
    const routine = join('routine','、') || 'なし';
    const location = val('location') || '【任意・未記入】';
    const workstyle = join('workstyle','・') || '【未記入】';
    const budget = join('budget','・') || '【未記入】';
    const transport = join('transport','・') || '【未記入】';
    const tone = getSelected('tone')[0] || '【未記入】';
    const period = getSelected('period')[0] || '【未記入】';
    const catLines = categories.map(c=>'  - '+c+': '+catState[c]+'個').join('\n');

    return '【子供の季節の活動リストを作ってほしい】\n\n'+
'■ 子供について\n'+
'- 年齢: '+age+'\n'+
'- 性格・行動特性: '+personality+'\n'+
'- 得意な受け取り方・好きな遊び: '+strengths+'\n'+
'- 苦手・避けたいこと: '+dislikes+'\n'+
'- すでにやっている日課(重複提案を避けてほしい): '+routine+'\n\n'+
'■ 条件\n'+
'- 居住地: '+location+'\n'+
'- 動ける日: '+workstyle+'\n'+
'- 予算感: '+budget+'\n'+
'- 移動手段: '+transport+'\n\n'+
'■ 欲しいリストの性質\n'+
'- カテゴリと各個数(最大5個。0は不要):\n'+catLines+'\n'+
'- トーン: '+tone+'\n'+
'- 対象期間: '+period+'\n\n'+
'■ 情報の質について(ここが一番重要)\n'+
'- まとめサイト(いこーよ・じゃらん等)より、区役所・自治体・公園管理団体・\n'+
'  地域の団体・施設公式サイトが出している一次情報を優先してほしい\n'+
'- 日付・料金・対象年齢がわかるものは明記してほしい\n'+
'- 確認できていない情報は「推測」「要確認」と明記し、事実と推測を混ぜないでほしい\n'+
'- そのカテゴリで条件に合う情報が見つからなければ、無理に埋めずに「該当なし」と\n'+
'  明記してほしい。存在しないものを作るより、ないと言われる方がいい\n'+
'- 出典のURLがあれば示してほしい\n\n'+
'■ 出力形式\n'+
'- カテゴリごとに見出しを立て、1項目1〜2行のリスト\n'+
'- 各カテゴリの最後に、実際に見つかった件数(指定数に届かなければその旨も)を記す\n'+
'- 最後に「特に良さそうなもの」を3つ選んでハイライトしてほしい';
  }

  document.getElementById('genBtn').addEventListener('click', () => {
    document.getElementById('outputText').textContent = buildPrompt();
    document.getElementById('output').classList.add('show');
    document.getElementById('output').scrollIntoView({behavior:'smooth',block:'start'});
  });
  document.getElementById('copyBtn').addEventListener('click', () => {
    const text = document.getElementById('outputText').textContent;
    navigator.clipboard.writeText(text).then(() => {
      const btn = document.getElementById('copyBtn');
      btn.textContent = 'コピーしました'; btn.classList.add('copied');
      setTimeout(()=>{ btn.textContent='コピー'; btn.classList.remove('copied'); },1800);
    });
  });

  ['btnChatGPT','btnClaude','btnGemini'].forEach(id => {
    const el = document.getElementById(id);
    el.addEventListener('click', () => {
      const text = document.getElementById('outputText').textContent;
      if (text && navigator.clipboard) {
        navigator.clipboard.writeText(text).then(() => {
          const orig = el.textContent;
          el.classList.add('done'); el.textContent = 'コピー済→開いて貼付';
          setTimeout(()=>{ el.textContent = orig; el.classList.remove('done'); }, 2200);
        }).catch(()=>{});
      }
    });
  });
</script>
</body>
</html>

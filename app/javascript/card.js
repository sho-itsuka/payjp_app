const pay = () => {
  Payjp.setPublicKey(process.env.PAYJP_PUBLIC_KEY); //環境変数を読み込む
    const submit = document.getElementById("button"); //変数submitにid"button"の要素を取得し代入
    submit.addEventListener("click", (e) => { //イベント発火
    e.preventDefault(); //Railsのフォーム送信処理をキャンセルし、JavaScriptからサーバーサイドに値を送るようにする記述

    //カード情報の取得先
    const formResult = document.getElementById("charge-form"); //カード登録の入力フォームに付与されているid名
    const formData = new FormData(formResult);

    const card = {  //カードオブジェクトを生成
      number: formData.get("number"),               //カード番号
      cvc: formData.get("cvc"),                     //カード裏面の3桁の番号
      exp_month: formData.get("exp_month"),         //有効期限の月
      exp_year: `20${formData.get("exp_year")}`,    //有効期限の年
    };

    //カードオブジェクトをPAY.JPに送信
    Payjp.createToken(card, (status, response) => {
      if (status === 200) {
        const token = response.id;
        const renderDom = document.getElementById("charge-form");
        const tokenObj = `<input value=${token} name='card_token' type="hidden">`;
        renderDom.insertAdjacentHTML("beforeend", tokenObj);
      }
      //カード情報がparamsに含まれないための記述
      document.getElementById("number").removeAttribute("name");
      document.getElementById("cvc").removeAttribute("name");
      document.getElementById("exp_month").removeAttribute("name");
      document.getElementById("exp_year").removeAttribute("name");
      
      //トークンをコントローラーに送信
      document.getElementById("charge-form").submit();
    });
  });
};

window.addEventListener("load", pay);
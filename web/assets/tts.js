function speakText(text, lang) {
  const msg = new SpeechSynthesisUtterance(text);
  msg.lang = lang || 'en-US';
  msg.rate = 0.9;
  window.speechSynthesis.cancel();
  window.speechSynthesis.speak(msg);
}

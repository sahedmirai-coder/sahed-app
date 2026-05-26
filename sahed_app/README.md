# Sahed VoIP Dialer App

## বিনামূল্যে APK বানানোর ধাপ (GitHub দিয়ে)

### ধাপ ১ — GitHub অ্যাকাউন্ট বানান
👉 https://github.com/signup এ গিয়ে ফ্রি অ্যাকাউন্ট খুলুন

---

### ধাপ ২ — নতুন Repository তৈরি করুন
1. https://github.com/new এ যান
2. Repository name: `sahed-app`
3. **Private** সিলেক্ট করুন
4. **Create repository** চাপুন

---

### ধাপ ৩ — ফাইলগুলো আপলোড করুন
1. Repository পেজে **"uploading an existing file"** লিংকে চাপুন
2. এই ZIP ফাইলের সব ফাইল ড্র্যাগ করে আপলোড করুন
3. **Commit changes** চাপুন

---

### ধাপ ৪ — APK বিল্ড হওয়া দেখুন
1. Repository-তে **Actions** ট্যাবে যান
2. **"Build Sahed APK"** workflow দেখবেন — চলছে
3. ৫-১০ মিনিট অপেক্ষা করুন
4. সবুজ টিক ✅ দেখলে **Artifacts** থেকে APK ডাউনলোড করুন

---

### ধাপ ৫ — Android-এ ইনস্টল করুন
1. APK ডাউনলোড করুন
2. Settings → Security → **Unknown sources** চালু করুন
3. APK ফাইলে ট্যাপ করুন → Install

---

## অ্যাপ কী করে?
- খুললেই সরাসরি `https://amarip.net/#dialer` লোড হয়
- মাইক্রোফোন permission স্বয়ংক্রিয়ভাবে নেয়
- সুন্দর Splash screen সহ
- ইন্টারনেট না থাকলে বাংলায় error দেখায়

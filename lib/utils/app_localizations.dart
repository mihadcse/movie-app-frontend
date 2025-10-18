// App Localization Strings
// This file contains all translatable strings for the CineMatch app

class AppLocalizations {
  final String languageCode;

  AppLocalizations(this.languageCode);

  static AppLocalizations of(String languageCode) {
    return AppLocalizations(languageCode);
  }

  // Common
  String get appName => languageCode == 'bn' ? 'সিনেম্যাচ' : 'CineMatch';
  String get loading => languageCode == 'bn' ? 'লোড হচ্ছে...' : 'Loading...';
  String get error => languageCode == 'bn' ? 'ত্রুটি' : 'Error';
  String get success => languageCode == 'bn' ? 'সফল' : 'Success';
  String get cancel => languageCode == 'bn' ? 'বাতিল' : 'Cancel';
  String get ok => languageCode == 'bn' ? 'ঠিক আছে' : 'OK';
  String get save => languageCode == 'bn' ? 'সংরক্ষণ করুন' : 'Save';
  String get delete => languageCode == 'bn' ? 'মুছে ফেলুন' : 'Delete';
  String get edit => languageCode == 'bn' ? 'সম্পাদনা' : 'Edit';
  String get search => languageCode == 'bn' ? 'খুঁজুন' : 'Search';
  String get filter => languageCode == 'bn' ? 'ফিল্টার' : 'Filter';
  String get sort => languageCode == 'bn' ? 'সাজান' : 'Sort';
  
  // Bottom Navigation
  String get home => languageCode == 'bn' ? 'হোম' : 'Home';
  String get searchTab => languageCode == 'bn' ? 'খুঁজুন' : 'Search';
  String get watchlist => languageCode == 'bn' ? 'ওয়াচলিস্ট' : 'Watchlist';
  String get profile => languageCode == 'bn' ? 'প্রোফাইল' : 'Profile';

  // Login Page
  String get welcomeBack => languageCode == 'bn' ? 'আবার স্বাগতম! সাইন ইন করতে চালিয়ে যান' : 'Welcome back! Sign in to continue';
  String get signIn => languageCode == 'bn' ? 'সাইন ইন' : 'Sign In';
  String get email => languageCode == 'bn' ? 'ইমেইল' : 'Email';
  String get password => languageCode == 'bn' ? 'পাসওয়ার্ড' : 'Password';
  String get forgotPassword => languageCode == 'bn' ? 'পাসওয়ার্ড ভুলে গেছেন?' : 'Forgot Password?';
  String get dontHaveAccount => languageCode == 'bn' ? 'কোন অ্যাকাউন্ট নেই?' : "Don't have an account?";
  String get signUp => languageCode == 'bn' ? 'সাইন আপ' : 'Sign Up';
  String get enterEmail => languageCode == 'bn' ? 'আপনার ইমেইল ঠিকানা লিখুন' : 'Enter your email address';
  String get enterPassword => languageCode == 'bn' ? 'আপনার পাসওয়ার্ড লিখুন' : 'Enter your password';
  String get pleaseEnterEmail => languageCode == 'bn' ? 'আপনার ইমেইল লিখুন' : 'Please enter your email';
  String get pleaseEnterPassword => languageCode == 'bn' ? 'আপনার পাসওয়ার্ড লিখুন' : 'Please enter your password';
  String get invalidEmail => languageCode == 'bn' ? 'একটি বৈধ ইমেইল ঠিকানা লিখুন' : 'Please enter a valid email address';
  String get passwordTooShort => languageCode == 'bn' ? 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে' : 'Password must be at least 6 characters';
  String get loginSuccessful => languageCode == 'bn' ? 'লগইন সফল!' : 'Login successful!';
  String get loginFailed => languageCode == 'bn' ? 'লগইন ব্যর্থ' : 'Login failed';
  String get or => languageCode == 'bn' ? 'অথবা' : 'OR';
  String get continueWithGoogle => languageCode == 'bn' ? 'Google দিয়ে চালিয়ে যান' : 'Continue with Google';
  String get continueWithApple => languageCode == 'bn' ? 'Apple দিয়ে চালিয়ে যান' : 'Continue with Apple';

  // Register Page
  String get joinCineMatch => languageCode == 'bn' ? 'সিনেম্যাচ এ যোগদান করুন' : 'Join CineMatch';
  String get createAccountDescription => languageCode == 'bn' ? 'আপনার নিখুঁত মুভি আবিষ্কার করতে একটি অ্যাকাউন্ট তৈরি করুন' : 'Create an account to discover your perfect movies';
  String get createAccount => languageCode == 'bn' ? 'অ্যাকাউন্ট তৈরি করুন' : 'Create Account';
  String get fullName => languageCode == 'bn' ? 'পূর্ণ নাম' : 'Full Name';
  String get enterFullName => languageCode == 'bn' ? 'আপনার পূর্ণ নাম লিখুন' : 'Enter your full name';
  String get confirmPassword => languageCode == 'bn' ? 'পাসওয়ার্ড নিশ্চিত করুন' : 'Confirm Password';
  String get reEnterPassword => languageCode == 'bn' ? 'আবার পাসওয়ার্ড লিখুন' : 'Re-enter your password';
  String get aboutYou => languageCode == 'bn' ? 'আপনার সম্পর্কে (ঐচ্ছিক)' : 'About You (Optional)';
  String get tellUsAboutPreferences => languageCode == 'bn' ? 'আপনার মুভি পছন্দ সম্পর্কে বলুন...' : 'Tell us about your movie preferences...';
  String get acceptTerms => languageCode == 'bn' ? 'আমি সম্মত' : 'I agree to the';
  String get termsOfService => languageCode == 'bn' ? 'সেবা শর্তাবলী' : 'Terms of Service';
  String get and => languageCode == 'bn' ? 'এবং' : 'and';
  String get privacyPolicy => languageCode == 'bn' ? 'গোপনীয়তা নীতি' : 'Privacy Policy';
  String get alreadyHaveAccount => languageCode == 'bn' ? 'ইতিমধ্যে একটি অ্যাকাউন্ট আছে?' : 'Already have an account?';
  String get pleaseEnterName => languageCode == 'bn' ? 'আপনার নাম লিখুন' : 'Please enter your name';
  String get nameTooShort => languageCode == 'bn' ? 'নাম কমপক্ষে ২ অক্ষরের হতে হবে' : 'Name must be at least 2 characters';
  String get passwordTooShort8 => languageCode == 'bn' ? 'পাসওয়ার্ড কমপক্ষে ৮ অক্ষরের হতে হবে' : 'Password must be at least 8 characters';
  String get passwordRequirements => languageCode == 'bn' ? 'পাসওয়ার্ডে বড় হাতের, ছোট হাতের এবং সংখ্যা থাকতে হবে' : 'Password must contain uppercase, lowercase, and number';
  String get passwordsDoNotMatch => languageCode == 'bn' ? 'পাসওয়ার্ড মিলছে না' : 'Passwords do not match';
  String get pleaseAcceptTerms => languageCode == 'bn' ? 'দয়া করে শর্তাবলী গ্রহণ করুন' : 'Please accept the terms and conditions';
  String get accountCreated => languageCode == 'bn' ? 'অ্যাকাউন্ট সফলভাবে তৈরি হয়েছে! লগইন করুন।' : 'Account created successfully! Please login.';
  String get registrationFailed => languageCode == 'bn' ? 'নিবন্ধন ব্যর্থ' : 'Registration failed';

  // Home Page
  String get popularMovies => languageCode == 'bn' ? 'জনপ্রিয় মুভি' : 'Popular Movies';
  String get trendingNow => languageCode == 'bn' ? 'এখন ট্রেন্ডিং' : 'Trending Now';
  String get newReleases => languageCode == 'bn' ? 'নতুন রিলিজ' : 'New Releases';
  String get watchNow => languageCode == 'bn' ? 'এখনই দেখুন' : 'Watch Now';
  String get loadingMovies => languageCode == 'bn' ? 'মুভি লোড হচ্ছে...' : 'Loading movies...';
  String get failedToLoad => languageCode == 'bn' ? 'লোড করতে ব্যর্থ' : 'Failed to load';
  String get retry => languageCode == 'bn' ? 'পুনরায় চেষ্টা করুন' : 'Retry';

  // Search Page
  String get searchMovies => languageCode == 'bn' ? 'মুভি খুঁজুন...' : 'Search movies...';
  String get searchByTitle => languageCode == 'bn' ? 'শিরোনাম দিয়ে মুভি খুঁজুন...' : 'Search movies by title...';
  String get recentSearches => languageCode == 'bn' ? 'সাম্প্রতিক অনুসন্ধান' : 'Recent Searches';
  String get clearAll => languageCode == 'bn' ? 'সব মুছে ফেলুন' : 'Clear All';
  String get noResultsFound => languageCode == 'bn' ? 'কোন ফলাফল পাওয়া যায়নি' : 'No results found';
  String get tryDifferentKeywords => languageCode == 'bn' ? 'বিভিন্ন কীওয়ার্ড ব্যবহার করে দেখুন' : 'Try different keywords';
  String get genre => languageCode == 'bn' ? 'ধরন' : 'Genre';
  String get year => languageCode == 'bn' ? 'বছর' : 'Year';
  String get rating => languageCode == 'bn' ? 'রেটিং' : 'Rating';
  String get allGenres => languageCode == 'bn' ? 'সব ধরন' : 'All Genres';

  // Watchlist Page
  String get myWatchlist => languageCode == 'bn' ? 'আমার ওয়াচলিস্ট' : 'My Watchlist';
  String get toWatch => languageCode == 'bn' ? 'দেখতে হবে' : 'To Watch';
  String get watching => languageCode == 'bn' ? 'দেখছি' : 'Watching';
  String get watched => languageCode == 'bn' ? 'দেখা হয়েছে' : 'Watched';
  String get emptyWatchlist => languageCode == 'bn' ? 'আপনার ওয়াচলিস্ট খালি' : 'Your watchlist is empty';
  String get addMoviesDescription => languageCode == 'bn' ? 'আপনার প্রিয় মুভি যোগ করুন এবং ট্র্যাক করুন' : 'Add and track your favorite movies';
  String get exploreMovies => languageCode == 'bn' ? 'মুভি এক্সপ্লোর করুন' : 'Explore Movies';

  // Profile Page
  String get accountSettings => languageCode == 'bn' ? 'অ্যাকাউন্ট সেটিংস' : 'Account Settings';
  String get geminiAIChat => languageCode == 'bn' ? 'জেমিনি AI চ্যাট' : 'Gemini AI Chat';
  String get myRatings => languageCode == 'bn' ? 'আমার রেটিংস' : 'My Ratings';
  String get moodDiscovery => languageCode == 'bn' ? 'মুড ডিসকভারি' : 'Mood Discovery';
  String get darkMode => languageCode == 'bn' ? 'ডার্ক মোড' : 'Dark Mode';
  String get logout => languageCode == 'bn' ? 'লগআউট' : 'Logout';
  String get logoutConfirmation => languageCode == 'bn' ? 'আপনি কি নিশ্চিত লগআউট করতে চান?' : 'Are you sure you want to logout?';
  String get loggingOut => languageCode == 'bn' ? 'লগআউট হচ্ছে...' : 'Logging out...';
  String get successfullyLoggedOut => languageCode == 'bn' ? 'সফলভাবে লগআউট হয়েছে' : 'Successfully logged out';
  String get myRecentRatings => languageCode == 'bn' ? 'আমার সাম্প্রতিক রেটিং' : 'My Recent Ratings';
  String get seeAll => languageCode == 'bn' ? 'সব দেখুন' : 'See All';

  // Settings Page
  String get language => languageCode == 'bn' ? 'ভাষা' : 'Language';
  String get currentLanguage => languageCode == 'bn' ? 'বর্তমান ভাষা' : 'Current language';
  String get languageChanged => languageCode == 'bn' ? 'ভাষা পরিবর্তন হয়েছে' : 'Language changed';
  String get languagePreferenceSaved => languageCode == 'bn' ? 'ভাষা পছন্দ সংরক্ষিত এবং পুরো অ্যাপে প্রয়োগ করা হবে।' : 'Language preference is saved and will be applied throughout the app.';
  String get note => languageCode == 'bn' ? 'নোট' : 'Note';

  // Movie Details
  String get cast => languageCode == 'bn' ? 'কাস্ট' : 'Cast';
  String get director => languageCode == 'bn' ? 'পরিচালক' : 'Director';
  String get duration => languageCode == 'bn' ? 'সময়কাল' : 'Duration';
  String get releaseDate => languageCode == 'bn' ? 'মুক্তির তারিখ' : 'Release Date';
  String get overview => languageCode == 'bn' ? 'সংক্ষিপ্ত বিবরণ' : 'Overview';
  String get rateThisMovie => languageCode == 'bn' ? 'এই মুভিটি রেট করুন' : 'Rate this Movie';
  String get yourRating => languageCode == 'bn' ? 'আপনার রেটিং' : 'Your Rating';
  String get submit => languageCode == 'bn' ? 'জমা দিন' : 'Submit';
  String get submitting => languageCode == 'bn' ? 'জমা দেওয়া হচ্ছে...' : 'Submitting...';

  // Chat/Gemini Page
  String get askMeAnything => languageCode == 'bn' ? 'আমাকে কিছু জিজ্ঞাসা করুন...' : 'Ask me anything...';
  String get send => languageCode == 'bn' ? 'পাঠান' : 'Send';
  String get geminiAI => languageCode == 'bn' ? 'জেমিনি AI' : 'Gemini AI';
  String get yourMovieCompanion => languageCode == 'bn' ? 'আপনার মুভি সঙ্গী' : 'Your Movie Companion';
  String get startConversation => languageCode == 'bn' ? 'কথোপকথন শুরু করুন...' : 'Start a conversation...';

  // Mood Discovery
  String get howAreYouFeeling => languageCode == 'bn' ? 'আপনি কেমন অনুভব করছেন?' : 'How are you feeling?';
  String get selectYourMood => languageCode == 'bn' ? 'আপনার মুড নির্বাচন করুন' : 'Select your mood';
  String get aiPoweredRecommendations => languageCode == 'bn' ? 'AI চালিত সুপারিশ' : 'AI-Powered Recommendations';
  
  // Common Movie Terms
  String get action => languageCode == 'bn' ? 'অ্যাকশন' : 'Action';
  String get comedy => languageCode == 'bn' ? 'কমেডি' : 'Comedy';
  String get drama => languageCode == 'bn' ? 'ড্রামা' : 'Drama';
  String get horror => languageCode == 'bn' ? 'হরর' : 'Horror';
  String get romance => languageCode == 'bn' ? 'রোম্যান্স' : 'Romance';
  String get thriller => languageCode == 'bn' ? 'থ্রিলার' : 'Thriller';
  String get sciFi => languageCode == 'bn' ? 'সায়েন্স ফিকশন' : 'Sci-Fi';
  String get fantasy => languageCode == 'bn' ? 'ফ্যান্টাসি' : 'Fantasy';
}

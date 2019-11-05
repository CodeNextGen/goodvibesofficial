
import 'package:goodvibes/pages/about/about.dart';
import 'package:goodvibes/pages/initial/splash.dart';
import 'package:goodvibes/pages/offline.dart';
import 'package:goodvibes/pages/reminder/reminder_page.dart';
import 'package:goodvibes/pages/user/email_signin.dart';
import 'package:goodvibes/pages/user/login.dart';
import 'package:goodvibes/pages/user/profile_page.dart';
import 'pages/faq/faq.dart';
import 'pages/home/home.dart';
import 'pages/initial/intro_page.dart';
import 'pages/music/album_songs.dart';
import 'pages/music/downloads.dart';
import 'pages/music/fav_tracks_page.dart';
import 'pages/music/genre_songs.dart';
import 'pages/music/history_tracks_page.dart';
import 'pages/payments/subscription.dart';
import 'pages/reminder/delete_reminder.dart';
import 'pages/reminder/set_reminder.dart';
import 'pages/user/ask_question.dart';
import 'pages/user/forgot_password.dart';

var routes = {
  'splash': (context) => Splash(),
  'offline': (context) => NoInternet(),
  'login': (context) => LoginPage(),
  'profile': (context) => UserProfile(),
  'albumsongs': (context) => AlbumSongs(),
  'intro': (context) => IntroPage(),
  'forgotPassword': (context) => ForgetPassword(),
  'home': (context) => HomePageNew(),
  'favs': (context) => FavsMusicList(),
  'download': (context) => DownloadedMusic(),
  'about': (context) => AboutUs(),
  'faq': (context) => FaqPage(),
  'history': (context) => HistoryMusicList(),
  'askQuestion': (context) => AskQuestion(),
  'genreSongs': (context) => GenreSongs(),
  'subscribe': (context) => SubscriptionPage(),
  'emaillogin': (context) => SignInEmail(),
  'reminder': (context) => ReminderPage(),
  'addNewReminder': (context) => AddNewReminder(),
  'deleteReminders': (context) => DeleteReminders(),

};
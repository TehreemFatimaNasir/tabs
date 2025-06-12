import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;
import 'package:just_audio/just_audio.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: tabs(),
    );
  }
}

class tabs extends StatefulWidget {
  const tabs({super.key});

  @override
  State<tabs> createState() => _tabsState();
}

class _tabsState extends State<tabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3, child: Scaffold(
      appBar: AppBar(
        title: Text("Noor al-Quloob"),
         bottom: TabBar(
          tabs:[
          Tab(text: "Mushaf"),
          Tab(text: "Salah times"),
          Tab(text: " Books Library"),
         ]),
      ),
      body: TabBarView(children: [Quranapp(),Prayertimes(),books()]),
    )
    );
  }
}class Quranapp extends StatefulWidget {
  const Quranapp({super.key});

  @override
  State<Quranapp> createState() => _QuranappState();
}

class _QuranappState extends State<Quranapp> {
@override
 void initState() {
    super.initState();
    Timer(
       Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>   buttonscreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff2193b0), Color(0xff6dd5ed)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            "Mushaf",
            style: GoogleFonts.amiriQuran(fontSize: 35, color: Color(0xFFFFF8E7)),
          ),
        ),
      ),
    );
  }
}

class SurahScreen extends StatefulWidget {
  const SurahScreen({super.key});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/images/QURAN.png",
          width: 100,
          height: 100,
        ),
      ),
      body: ListView.builder(
        itemCount: 114,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => detailsurah(index + 1),
                ),
              );
            },
            leading: CircleAvatar(
                      backgroundColor: Color(0xFF00ACC2),
                foregroundColor: Colors.white,
              child: Text("${index + 1}"),
            ),
            title:Text(quran.getSurahNameArabic(index+1),style: GoogleFonts.amiriQuran(),),
            subtitle: Text(quran.getSurahName(index+1)),
            trailing: Column(
              children: [
                quran.getPlaceOfRevelation(index+1)=="Makkah"?
                Image.asset("assets/images/Makkah.png",width: 30,
                          height: 30,):
                          Image.asset("assets/images/madina.png", 
                           width: 30,
                          height: 30,),
                        Text("verses"+quran.getVerseCount(index+1).toString()),
              ],),
          );
        },
      ),
    );
  }
}
class detailsurah extends StatefulWidget {
 var surahnumber;

  
  detailsurah(this.surahnumber, {super.key});

  @override
  State<detailsurah> createState() => _detailsurahState();
}

class _detailsurahState extends State<detailsurah> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          quran.getSurahNameArabic(widget.surahnumber),
          style: GoogleFonts.amiriQuran(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: ListView.builder(
            itemCount: quran.getVerseCount(widget.surahnumber),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  quran.getVerse(widget.surahnumber, index + 1, verseEndSymbol: true),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.amiri(),
                ),
                subtitle: Text(
                  quran.getVerseTranslation(widget.surahnumber, index + 1,
                      translation: quran.Translation.urdu),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.notoNastaliqUrdu(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
class audio extends StatefulWidget {
  var surahnumber;
 audio(this.surahnumber,{super.key});

  @override
  State<audio> createState() => _audioState();
}

class _audioState extends State<audio> {
  AudioPlayer audioPlayer = AudioPlayer();
  IconData playpausebtn =Icons.play_arrow_rounded;
  bool isplaying = true;

  ToggleButton()async{
    final audiourl = await quran.getAudioURLBySurah(widget.surahnumber);
    audioPlayer.setUrl(audiourl);
if(isplaying){
  audioPlayer.play();
  setState(() {
    isplaying=false;
     playpausebtn = Icons.pause;
  });
}else{
  audioPlayer.pause();
  setState(() {
    isplaying=true;
     playpausebtn = Icons.play_arrow_rounded;
  });
}
  }
 @override
 void dispose(){
  super.dispose();
  audioPlayer.dispose();
 }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(quran.getSurahNameArabic(widget.surahnumber),style: GoogleFonts.amiriQuran(fontSize: 30),
          ),
          CircleAvatar(radius: 100,  backgroundColor: Color(0xFF2596BE),backgroundImage: AssetImage("assets/images/alafasy.jpg"),),
          Container(width: double.infinity,color: Color(0xFF2596BE),child: IconButton(onPressed: ToggleButton, icon: Icon(
            playpausebtn,color: Colors.white,
          )),),
          ],
        ),
      ),
    );
  }
}
class buttonscreen extends StatefulWidget {
  const buttonscreen({super.key});

  @override
  State<buttonscreen> createState() => _buttonscreenState();
}

class _buttonscreenState extends State<buttonscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>SurahScreen(),));},
           child: Text("Read Quran")),SizedBox(height: 16,),

          ElevatedButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>audioscreen()));}, 
          child: Text("listen Quran")),SizedBox(height: 16,),
        ],
        ),
      ),
    );
  }
}

class audioscreen extends StatefulWidget {
  const audioscreen({super.key});

  @override
  State<audioscreen> createState() => _audioscreenState();
}

class _audioscreenState extends State<audioscreen> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/images/QURAN.png",
          width: 100,
          height: 100,
        ),
      ),
      body: ListView.builder(
        itemCount: 114,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => audio(index + 1),
                ),
              );
            },
            leading: CircleAvatar(
               backgroundColor: Color(0xFF00ACC2),
                foregroundColor: Colors.white,
              child: Text("${index + 1},"),
            ),
            
            title:Text(quran.getSurahNameArabic(index+1),style: GoogleFonts.amiriQuran(),), 
            subtitle: Text("Sheikh Mishary",style: GoogleFonts.openSans(fontSize: 14, color: Colors.grey[700]),),
            trailing: Column(
              children: [
                quran.getPlaceOfRevelation(index+1)=="Makkah"?
                Image.asset("assets/images/Makkah.png",width: 30,
                          height: 30,):
                          Image.asset("assets/images/madina.png", 
                           width: 30,
                          height: 30,),
                        Text("verses"+quran.getVerseCount(index+1).toString()),
              ],),
          );
        },
      ),
    );
  }
}
class Prayertimes extends StatefulWidget {
  const Prayertimes({super.key});

  @override
  State<Prayertimes> createState() => _PrayertimesState();
}

class _PrayertimesState extends State<Prayertimes> {
  var time = DateTime.now();
  final myCoordinates = Coordinates(24.8607, 67.0011);
  late  PrayerTimes? todayPrayerTimes;

  @override
  void initState() {
    super.initState();
    _calculatePrayerTimes();
  }

  void _calculatePrayerTimes() {
    final params = CalculationMethod.karachi.getParameters();
    params.madhab = Madhab.hanafi;
    final prayerTimes = PrayerTimes.today(
      myCoordinates,
      params,
    );
    setState(() {
      todayPrayerTimes = prayerTimes;
    });
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Color(0xFF29B6F6),
      title: Center(
        child: Text(
          'Karachi, Pakistan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
             Text("Fajr:", style: TextStyle(fontSize: 18)),
             Text(DateFormat.jm().format(todayPrayerTimes!.fajr), style: TextStyle(fontSize: 18)),
             Text("Sunrise:", style: TextStyle(fontSize: 18)),
             Text(DateFormat.jm().format(todayPrayerTimes!.sunrise), style: TextStyle(fontSize: 18)),
             Text("Dhuhr:", style: TextStyle(fontSize: 18)),
             Text(DateFormat.jm().format(todayPrayerTimes!.dhuhr), style: TextStyle(fontSize: 18)),
              Text("Asr:", style: TextStyle(fontSize: 18)),
             Text(DateFormat.jm().format(todayPrayerTimes!.asr), style: TextStyle(fontSize: 18)),
              Text("Maghrib:", style: TextStyle(fontSize: 18)),
             Text(DateFormat.jm().format(todayPrayerTimes!.maghrib), style: TextStyle(fontSize: 18)),
              Text("Isha:", style: TextStyle(fontSize: 18)),
          Text(DateFormat.jm().format(todayPrayerTimes!.isha), style: TextStyle(fontSize: 18)),
        ],
      ),
    ),
  );
}
}
class books extends StatefulWidget {
  const books ({super.key});
  @override
  State<books > createState() => _booksState();
}

class _booksState extends State<books > {
    List bookList = [
    {"name": "The Virtues of Dhul-Hijjah", "location": "assets/images/Dhul-Hijjah-Virtues-Abu-Khadeejah.pdf"},
    {"name": "Salat-The Muslim Prayer  ", "location": "assets/images/Salat-The-Muslim-Prayer.pdf"},
    {"name": "The Sealed Nectar ", "location": "assets/images/THE_SEALED_NECTAR.pdf"},
     {"name": "Seerat e Mustafa SAW", "location": "assets/images/Seerat e Mustafa.pdf"},
  ];
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: bookList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Pdf(index)),
              );
            },
            leading: CircleAvatar(child: Text("${index + 1}")),
            title: Text(bookList[index]["name"]),
          );
        },
      ),
    );
  }
}

class Pdf extends StatefulWidget {
  var bookNumber;
  Pdf(this.bookNumber, {super.key});

  @override
  State<Pdf> createState() => _PdfSCRState();
}

class _PdfSCRState extends State<Pdf> {
  List bookList = [
    {"name": "The Virtues of Dhul-Hijjah", "location": "assets/images/Dhul-Hijjah-Virtues-Abu-Khadeejah.pdf"},
    {"name": "Salat-The Muslim Prayer  ", "location": "assets/images/Salat-The-Muslim-Prayer.pdf"},
    {"name": "The Sealed Nectar ", "location": "assets/images/THE_SEALED_NECTAR.pdf"},
     {"name": "Seerat e Mustafa SAW", "location": "assets/images/Seerat e Mustafa.pdf"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.asset(bookList[widget.bookNumber]["location"]),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami_c13_monday/home/tabs/quran_tab/sura_name_horizontal_item.dart';
import 'package:islami_c13_monday/home/tabs/quran_tab/sura_name_item.dart';
import 'package:islami_c13_monday/models/sura_model.dart';
import 'package:islami_c13_monday/sura_details/sura_details_screen.dart';

class QuranTab extends StatefulWidget {
  QuranTab({super.key});

  @override
  State<QuranTab> createState() => _QuranTabState();
}

class _QuranTabState extends State<QuranTab> {
  var searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    searchController.addListener(onSearch);
  }

  onSearch() {
    SuraModel.searchResult.clear();
    String text = searchController.text;
    if (text.isNotEmpty) {
      for (String data in SuraModel.suraNamesEn) {
        if (data.toLowerCase().contains(text.toLowerCase())) {
          SuraModel.searchResult.add(data);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _searchItem(),
          SuraModel.searchResult.isNotEmpty || searchController.text.isNotEmpty
              ? SizedBox()
              : _suraHorizontalList(),
          _suraVerticalList(),
        ],
      ),
    );
  }

  Widget _suraVerticalList() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "Suras List",
            textAlign: TextAlign.start,
            style: GoogleFonts.elMessiri(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                indent: 40,
                endIndent: 40,
                thickness: 2,
              ),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, SuraDetailsScreen.routeName,
                        arguments: SuraModel.getSuraModel(index));
                  },
                  child: SuraNameItem(
                      model: SuraModel.searchResult.isNotEmpty
                          ? SuraModel.getSelectedSuraModel(index)
                          : SuraModel.getSuraModel(index)),
                );
              },
              itemCount: SuraModel.searchResult.isNotEmpty
                  ? SuraModel.searchResult.length
                  : SuraModel.listLength,
            ),
          )
        ],
      ),
    );
  }

  Widget _suraHorizontalList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Most Recently ",
          textAlign: TextAlign.start,
          style: GoogleFonts.elMessiri(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 150,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              width: 12,
            ),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return SuraNameHorizontalItem(
                model: SuraModel.getSuraModel(index),
              );
            },
            itemCount: SuraModel.listLength,
          ),
        ),
      ],
    );
  }

  Widget _searchItem() {
    return Column(
      children: [
        TextField(
          controller: searchController,
          cursorColor: const Color(0xFFE2BE7F),
          cursorWidth: 3,
          style: GoogleFonts.elMessiri(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            labelText: "Sura Name",
            fillColor: const Color(0xB3202020),
            filled: true,
            labelStyle: GoogleFonts.elMessiri(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            prefixIcon: Image.asset(
              "assets/images/quran.png",
              color: const Color(0xFFE2BE7F),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFE2BE7F),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2BE7F), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2BE7F), width: 2),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

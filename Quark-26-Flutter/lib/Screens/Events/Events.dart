import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quark_26_flutter/models/events.dart';
import 'package:quark_26_flutter/Widgets/EventCard.dart';
import 'package:quark_26_flutter/Widgets/EventTab.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Image.asset(
              height: 874.h,
              width: 402.w,
              "assets/gallery/gallery_bg_2.png",
              fit: BoxFit.cover,
            ),
            Center(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('events')
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                        color: Colors.white,
                        size: 45.r,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Text(
                          'Something went wrong. Please try again.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.r,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Text(
                          'No events yet.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.r,
                          ),
                        ),
                      ),
                    );
                  }

                  final events = snapshot.data!.docs
                      .map((doc) => Event.fromFirebase(
                          doc.data() as Map<String, dynamic>))
                      .toList();

                  final categories = _buildUniqueCategories(events);
                  final filteredEvents = _selectedCategory == null
                      ? events
                      : events
                          .where((e) => e.categoryName == _selectedCategory)
                          .toList();

                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.w),
                        child: Text(
                          'EVENTS',
                          style: TextStyle(
                            fontSize: 20.r,
                            fontFamily: 'Orbitron_Regular',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      if (categories.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: SizedBox(
                            height: 100.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                final cat = categories[index];
                                final isSelected =
                                    _selectedCategory == cat['name'];
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedCategory =
                                            isSelected ? null : cat['name'];
                                      });
                                    },
                                    child: Center(
                                      child: Eventtab(
                                        imageurl: cat['image']!,
                                        title: cat['title']!,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredEvents.length,
                          itemBuilder: (context, index) {
                            final event = filteredEvents[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Center(
                                child: EventCard(
                                  title: event.name,
                                  dateText: event.date.toString(),
                                  time: event.time,
                                  location: event.location,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _buildUniqueCategories(List<Event> events) {
    final seen = <String>{};
    final list = <Map<String, String>>[];
    for (final e in events) {
      if (e.categoryName.isNotEmpty && !seen.contains(e.categoryName)) {
        seen.add(e.categoryName);
        list.add({
          'name': e.categoryName,
          'title': e.categoryName,
          'image': e.categoryImageUrl,
        });
      }
    }
    return list;
  }
}

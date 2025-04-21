import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'detail_catatan_screen.dart';

class CatatanHarianScreen extends StatefulWidget {
  final Map<DateTime, Map<String, dynamic>> dailyRecords;

  const CatatanHarianScreen({
    Key? key,
    this.dailyRecords = const {},
  }) : super(key: key);

  @override
  _CatatanHarianScreenState createState() => _CatatanHarianScreenState();
}

class _CatatanHarianScreenState extends State<CatatanHarianScreen>
    with SingleTickerProviderStateMixin {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late Map<DateTime, Map<String, dynamic>> _dailyRecords;

  final List<Map<String, dynamic>> dummyData = [
    {
      'mood': 'satisfied',
      'catatan':
          'Hari ini cukup produktif, saya menyelesaikan banyak pekerjaan.',
      'factors': ['Pekerjaan'],
      'date': '2025-04-01T09:00:00Z',
    },
    {
      'mood': 'neutral',
      'catatan': 'Hari ini berjalan seperti biasa tanpa kejadian berarti.',
      'factors': ['Kesehatan'],
      'date': '2025-04-02T12:00:00Z',
    },
    {
      'mood': 'very_dissatisfied',
      'catatan': 'Hari ini sangat berat, banyak tekanan dari berbagai pihak.',
      'factors': ['Ekonomi', 'Keluarga'],
      'date': '2025-04-03T20:00:00Z',
    },
  ];

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);

    // Initialize daily records with dummy data
    _dailyRecords =
        Map<DateTime, Map<String, dynamic>>.from(widget.dailyRecords);

    for (var record in dummyData) {
      final date = DateTime.parse(record['date']);
      final normalizedDate = DateTime(date.year, date.month, date.day);
      _dailyRecords[normalizedDate] = {
        'mood': record['mood'],
        'catatan': record['catatan'],
        'factors': record['factors'],
      };
    }

    // Load additional records passed via route arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<DateTime, Map<String, dynamic>>) {
        setState(() {
          _dailyRecords.addAll(args);
        });
      }
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay =
          DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
      _focusedDay = focusedDay;
    });
    _animationController.reset();
    _animationController.forward();
  }

  String? _getMoodImagePath(DateTime date) {
    if (!_dailyRecords.containsKey(date)) return null;
    final mood = _dailyRecords[date]!['mood'];
    switch (mood) {
      case 'very_dissatisfied':
        return 'assets/Emoji_selected_very_dissatisfied.png';
      case 'dissatisfied':
        return 'assets/Emoji_selected_dissatisfied.png';
      case 'neutral':
        return 'assets/Emoji_selected_neutral.png';
      case 'satisfied':
        return 'assets/Emoji_selected_satisfied.png';
      case 'very_satisfied':
        return 'assets/Emoji_selected_very_satisfied.png';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayRecord = _dailyRecords[_selectedDay];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Harian'),
        backgroundColor: Colors.red,
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + 0.1 * _animationController.value,
            child: FloatingActionButton(
              onPressed: () {
                // Handle adding a new record
              },
              backgroundColor: Colors.red,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          );
        },
      ),
      body: Column(
        children: [
          TableCalendar(
            // Calendar configuration
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              _onDaySelected(selectedDay, focusedDay);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Tanggal dipilih: ${DateFormat('d MMMM yyyy', 'id_ID').format(selectedDay)}',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: (day) {
              final normalizedDay = DateTime(day.year, day.month, day.day);
              return _dailyRecords.containsKey(normalizedDay) ? [true] : [];
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.red[300],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              markerDecoration: BoxDecoration(
                color: Colors.red[400],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonDecoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              formatButtonTextStyle: const TextStyle(color: Colors.white),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.red),
              weekdayStyle: TextStyle(color: Colors.black),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: todayRecord != null
                    ? ScaleTransition(
                        scale: _animationController,
                        child: FadeTransition(
                          opacity: _animationController,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            elevation: 5,
                            child: SizedBox(
                              height: 250,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('d MMMM yyyy', 'id_ID')
                                            .format(_selectedDay),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          if (_getMoodImagePath(_selectedDay) !=
                                              null)
                                            Tooltip(
                                              message:
                                                  _dailyRecords[_selectedDay]
                                                      ?['mood'],
                                              child: Image.asset(
                                                _getMoodImagePath(
                                                    _selectedDay)!,
                                                width: 40,
                                                height: 40,
                                              ),
                                            ),
                                          const SizedBox(width: 10),
                                          if ((todayRecord['factors'] as List)
                                              .isNotEmpty)
                                            Chip(
                                              label: Text(
                                                (todayRecord['factors']
                                                        as List<String>)
                                                    .first,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        todayRecord['catatan']?.length > 50
                                            ? '${todayRecord['catatan']?.substring(0, 50)}...'
                                            : todayRecord['catatan'] ?? '',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {
                                            if (todayRecord['catatan']
                                                    ?.isNotEmpty ??
                                                false) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailCatatanScreen(
                                                          record: todayRecord),
                                                ),
                                              );
                                            }
                                          },
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              side: const BorderSide(
                                                  color: Colors.red),
                                            ),
                                            backgroundColor: Colors.red[50],
                                          ),
                                          child: const Text(
                                            'Lihat Detail',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox,
                            size: 100,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Tidak ada catatan untuk hari ini',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

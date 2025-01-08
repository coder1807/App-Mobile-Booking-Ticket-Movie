import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:movie_app/Screens/Client/Main/Views/Bookings/Movies/BookingDetailsPage.dart';
import 'package:movie_app/Themes/app_theme.dart';
import 'package:movie_app/manager/UserProvider.dart';
import 'package:provider/provider.dart';

class MyTicketsPage extends StatefulWidget {
  const MyTicketsPage({super.key});

  @override
  State<MyTicketsPage> createState() => _MyTicketsPageState();
}

class _MyTicketsPageState extends State<MyTicketsPage> {
  List<dynamic> tickets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).user!.id;
      final apiUrl = '${dotenv.env['MY_URL']}/booking?userId=$userId';
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          tickets = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load tickets');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching tickets: $e');
    }
  }

  String formatDate(String dateTime) {
    final parsedDate = DateTime.parse(dateTime);
    return DateFormat('dd/MM/yyyy - HH:mm').format(parsedDate);
  }

  String getShowTime(Map<String, dynamic> ticket) {
    DateTime startTime = DateTime.parse(ticket['startTime']);
    DateTime createAt = DateTime.parse(ticket['createAt']);
    DateTime startDate = DateTime(createAt.year, createAt.month, createAt.day,
        startTime.hour, startTime.minute);

    // So sánh giờ và phút của startTime với createAt
    if (startTime.isBefore(createAt)) {
      // Nếu giờ và phút của startTime nhỏ hơn createAt thì thay đổi ngày
      startDate = DateTime(createAt.year, createAt.month, createAt.day + 1,
          startTime.hour, startTime.minute);
    }

    // Trả về lịch chiếu đã được format
    return 'Suất chiếu: ${formatDate(startDate.toIso8601String())}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: AppTheme.colors.mainBackground,
        title: Text(
          'Lịch Sử Đặt Vé',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: AppTheme.colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,

      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : tickets.isEmpty
              ? const Center(
                  child: Text(
                    'Không tìm thấy vé',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    return _buildTicketCard(ticket);
                  },
                ),
    );
  }

  Widget _buildTicketCard(dynamic ticket) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingDetailsPage(
                ticket: ticket,
              ),
            ),
          );
        },
        child: Row(
          children: [
            // Poster phim
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(10)),
              child: Image.network(
                dotenv.env['API']! + ticket['poster'],
                width: 100,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 120,
                    color: Colors.grey,
                    child: const Icon(Icons.error, color: Colors.white),
                  );
                },
              ),
            ),
            // Chi tiết vé
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket['filmName'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      ticket['cinemaName'],
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      getShowTime(ticket),
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ghế: ${ticket['seatName']}',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

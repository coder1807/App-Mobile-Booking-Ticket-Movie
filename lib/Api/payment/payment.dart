
// Future<void> _getPaymentUrl() async {
//     // Tạo URL gọi API
//     final String paymentUrl =
//         '${dotenv.env['MY_URL']}/payment/create_momo?amount=${totalPrice.toInt()}&scheduleId=$scheduleId&comboId=$foodID&isMobile=true';

//     try {
//       // Gửi yêu cầu GET đến API
//       final response = await http.get(Uri.parse(paymentUrl));

//       if (response.statusCode == 200) {
//         // Parse JSON phản hồi
//         final jsonResponse = json.decode(response.body);

//         // Lấy URL từ key "payUrl"
//         final String? payUrl = jsonResponse['payUrl'];

//         if (payUrl != null) {
//           // Mở URL trong trình duyệt
//           if (await canLaunch(payUrl)) {
//             await launch(payUrl);
//           } else {
//             throw 'Could not launch $payUrl';
//           }
//         } else {
//           throw 'payUrl not found in response';
//         }
//       } else {
//         throw 'Failed to load payment URL';
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
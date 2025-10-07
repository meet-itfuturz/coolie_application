import 'package:coolie_application/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = [
      {
        "title": "Payment to Coolie #1234",
        "date": "09 Sep 2025, 11:30 AM",
        "amount": "- ₹120",
        "isCredit": false,
        "id": "TXN123456",
        "method": "UPI",
      },
      {
        "title": "Payment Received",
        "date": "08 Sep 2025, 05:15 PM",
        "amount": "+ ₹500",
        "isCredit": true,
        "id": "TXN789012",
        "method": "Bank Transfer",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Transaction History",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Constants.instance.primary,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final tx = transactions[index];
          return GestureDetector(
            onTap: () {
              _showTransactionDetails(context, tx);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: tx["isCredit"] == true
                        ? Colors.green.withOpacity(0.15)
                        : Colors.red.withOpacity(0.15),
                    child: Icon(
                      tx["isCredit"] == true
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded,
                      color: tx["isCredit"] == true ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx["title"].toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tx["date"].toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    tx["amount"].toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                      tx["isCredit"] == true ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showTransactionDetails(BuildContext context, Map tx) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // important for draggable
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.35,
          maxChildSize: 0.6,
          minChildSize: 0.3,
          expand: false,
          builder: (_, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                controller: scrollController, // connect controller
                children: [
                  Icon(Icons.arrow_drop_up,size: 29,),
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Text(
                    "Transaction Details",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 20),
                  _buildDetailRow("Title", tx["title"].toString()),
                  _buildDetailRow("Date & Time", tx["date"].toString()),
                  _buildDetailRow("Transaction ID", tx["id"].toString()),
                  _buildDetailRow("Payment Method", tx["method"].toString()),
                  _buildDetailRow(
                    "Amount",
                    tx["amount"].toString(),
                    valueColor: tx["isCredit"] == true ? Colors.green : Colors.red,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildDetailRow(String label, String value,
      {Color valueColor = Colors.black87}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

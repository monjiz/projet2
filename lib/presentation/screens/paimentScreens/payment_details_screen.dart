import 'package:auth_firebase/presentation/widgets/balance_card_widget.dart';
import 'package:flutter/material.dart';


class PaymentDetailsScreen extends StatefulWidget {
  @override
  _PaymentDetailsScreenState createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  String _selectedPaymentMethod = 'visa'; // 'visa', 'paypal', etc.
  bool _sendReceipt = true;

  Widget _buildPaymentMethodChip(String method, String assetPath, String label) {
    bool isSelected = _selectedPaymentMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue.shade400 : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 5, offset: Offset(0,2))
          ] : [],
        ),
        child: Row(
          children: [
            // Remplacer par Image.asset('assets/your_icon.png')
            Image.network(assetPath, height: 24, 
             errorBuilder: (context, error, stackTrace) => Icon(Icons.payment, size: 24, color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600),),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.blue.shade700 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(String name, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
          Text(price, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Payment details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 8),
            Text(
              'Select your payment method',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
SizedBox(height: 20),
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
      children: [
        _buildPaymentMethodChip(
            'visa',
            'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Visa_Inc._logo.svg/1200px-Visa_Inc._logo.svg.png',
            'VISA'),
        SizedBox(width: 8), // espace entre les chips
        _buildPaymentMethodChip(
            'paypal',
            'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/PayPal.svg/2560px-PayPal.svg.png',
            'PayPal'),
      ],
    ),
  ),
),

            SizedBox(height: 30),
            BalanceCardWidget(
              balance: '5,750.20',
              cardNumber: '5282 **** **** 1289', // Masqué pour l'affichage
              expiryDate: '09/25',
            ),
            SizedBox(height: 25),
            TextButton.icon(
              icon: Icon(Icons.add_circle_outline, color: Colors.blue.shade600),
              label: Text(
                'add a new card',
                style: TextStyle(color: Colors.blue.shade600, fontWeight: FontWeight.w500, fontSize: 16),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/addCard');
              },
            ),
            SizedBox(height: 20),
            Text(
              'Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            _buildCartItem('Satin Halter Top', '\$2,420'),
            Divider(color: Colors.grey.shade300),
            _buildCartItem('Satin Halter Top', '\$800'),
            Divider(color: Colors.grey.shade300),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Send receipt to my mail', style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
                Switch(
                  value: _sendReceipt,
                  onChanged: (value) {
                    setState(() {
                      _sendReceipt = value;
                    });
                  },
                  activeColor: Colors.blue.shade600,
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Price:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey.shade700)),
                Text('\$3,220.00', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0A7AFF))),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
     bottomNavigationBar: Padding(
  padding: const EdgeInsets.all(20.0),
  child: ElevatedButton(
    onPressed: () {
      // Logique de checkout
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue, // ✅ Couleur du bouton
      padding: EdgeInsets.symmetric(vertical: 8), // optionnel : agrandir le bouton
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5), // optionnel : bords arrondis
      ),
    ),
    child: Text(
      'Checkout',
      style: TextStyle(color: Colors.white, fontSize: 18),
    ),
  ),
),

    );
  }
}
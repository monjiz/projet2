import 'package:flutter/material.dart';

class BalanceCardWidget extends StatelessWidget {
  final String balance;
  final String cardNumber;
  final String expiryDate;
  final String
      cardTypeImageUrl; // URL pour l'image du type de carte (Mastercard/Visa)

  const BalanceCardWidget({
    Key? key,
    required this.balance,
    required this.cardNumber,
    required this.expiryDate,
    this.cardTypeImageUrl =
        'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/800px-Mastercard-logo.svg.png', // Placeholder Mastercard
  }) : super(key: key);

  @override
 Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Container(
        width: double.infinity, // ✅ Prend toute la largeur dispo sans déborder
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
            colors: [Color(0xFF2C3E50), Color(0xFF4A6DA7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// En-tête avec le logo carte
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Current Balance',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
                Image.network(
                  cardTypeImageUrl,
                  height: 25,
                  width: 40,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.credit_card, color: Colors.white, size: 25),
                ),
              ],
            ),

            SizedBox(height: 10),

            /// Solde
            Text(
              '\$${balance}',
              style: TextStyle(
                  color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 25),

            /// Numéro de carte + date d'expiration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Utiliser Flexible pour éviter débordement
                Flexible(
                  child: Text(
                    cardNumber.replaceAllMapped(RegExp(r".{4}"),
                        (match) => "${match.group(0)} "),
                    style: TextStyle(
                        color: Colors.white, fontSize: 18, letterSpacing: 1.5),
                    overflow: TextOverflow.ellipsis, // ✅ Protège contre débordement
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  expiryDate,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

}

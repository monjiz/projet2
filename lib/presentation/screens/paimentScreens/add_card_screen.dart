import 'package:auth_firebase/presentation/widgets/balance_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AddCardScreen extends StatefulWidget {
  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _cardHolderNameController = TextEditingController();
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _ccvController = TextEditingController();

  String _cardTypeImageUrl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/800px-Mastercard-logo.svg.png'; // Default to Mastercard

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_detectCardType);
  }

  void _detectCardType() {
    String cardNumber = _cardNumberController.text.replaceAll(" ", "");
    // Logique simple de détection de type de carte (à améliorer pour la production)
    if (cardNumber.startsWith('4')) {
      setState(() {
        _cardTypeImageUrl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Visa_Inc._logo.svg/1200px-Visa_Inc._logo.svg.png';
      });
    } else if (cardNumber.startsWith('5')) {
       setState(() {
        _cardTypeImageUrl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/800px-Mastercard-logo.svg.png';
      });
    } else {
       // Default ou autre
       setState(() {
         _cardTypeImageUrl = 'https://www.pngitem.com/pimgs/m/473-4739400_credit-card-logo-png-transparent-png.png'; // Generic card
       });
    }
  }


  @override
  void dispose() {
    _cardHolderNameController.dispose();
    _cardNumberController.removeListener(_detectCardType);
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _ccvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Payment details'), // Garder le même titre que l'écran précédent
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BalanceCardWidget(
                balance: '5,750.20',
                cardNumber: _cardNumberController.text.isEmpty 
                              ? '**** **** **** ****' 
                              : _cardNumberController.text.replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ").trim(),
                expiryDate: _expiryDateController.text.isEmpty ? 'MM/YY' : _expiryDateController.text,
                cardTypeImageUrl: _cardTypeImageUrl,
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _cardHolderNameController,
                decoration: InputDecoration(
                  labelText: 'Card Holder Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card holder name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.network(_cardTypeImageUrl, width: 20,
                       errorBuilder: (context, error, stackTrace) => Icon(Icons.credit_card, size: 20, color: Colors.grey),
                    ),
                  )
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  CardNumberInputFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty || value.replaceAll(" ", "").length != 16) {
                    return 'Please enter a valid 16-digit card number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryDateController,
                      decoration: InputDecoration(
                        labelText: 'Expiration Date',
                        hintText: 'MM/YY',
                      ),
                      keyboardType: TextInputType.datetime,
                       inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        CardMonthInputFormatter(),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty || !RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$').hasMatch(value)) {
                          return 'Enter MM/YY';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: _ccvController,
                      decoration: InputDecoration(
                        labelText: 'CCV',
                        hintText: '***'
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 3) {
                          return 'Enter CCV';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
       bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Logique pour ajouter la carte
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Card Added Successfully (Simulation)')),
              );
              Navigator.pop(context); // Revenir à l'écran précédent
            }
          },
          child: Text('Add Card', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}


// Formatters pour les champs de carte
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('  '); // Espace double pour plus de clarté
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length)
    );
  }
}

class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != newText.length) {
        buffer.write('/');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length)
    );
  }
}
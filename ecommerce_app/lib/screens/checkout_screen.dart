import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/cart_item.dart';
import 'package:flutter_ecommerce/screens/login_screen.dart';
import 'package:flutter_ecommerce/utils/app_theme.dart';
import 'package:flutter_ecommerce/widgets/custom_button.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cart;
  final double subtotal;
  final double tax;
  final double shipping;
  final double total;
  
  const CheckoutScreen({
    super.key,
    required this.cart,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.total,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  final _shippingFormKey = GlobalKey<FormState>();
  final _paymentFormKey = GlobalKey<FormState>();
  bool _isPlacingOrder = false;
  
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  
  final _cardNumberController = TextEditingController();
  final _cardNameController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _cardCvvController = TextEditingController();
  
  String _selectedPaymentMethod = 'Credit Card';
  final List<String> _paymentMethods = ['Credit Card', 'PayPal', 'Apple Pay'];
  
  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _cardNumberController.dispose();
    _cardNameController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    super.dispose();
  }
  
  void _placeOrder() {
    if (_currentStep == 2) {
      setState(() {
        _isPlacingOrder = true;
      });
      
      // Simulate order placement
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isPlacingOrder = false;
        });
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Order Placed!'),
            content: const Text('Your order has been placed successfully. Thank you for shopping with us!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }
  
  void _continueStep() {
    bool isLastStep = _currentStep >= 2;
    
    if (isLastStep) {
      _placeOrder();
      return;
    }
    
    bool canContinue = true;
    
    // Validate current step
    if (_currentStep == 0) {
      canContinue = _shippingFormKey.currentState!.validate();
    } else if (_currentStep == 1) {
      canContinue = _paymentFormKey.currentState!.validate();
    }
    
    if (canContinue) {
      setState(() {
        _currentStep += 1;
      });
    }
  }
  
  void _cancelStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stepper(
              currentStep: _currentStep,
              onStepTapped: (step) {
                setState(() {
                  _currentStep = step;
                });
              },
              controlsBuilder: (context, details) {
                return const SizedBox.shrink();
              },
              steps: [
                Step(
                  title: const Text('Shipping'),
                  content: _buildShippingStep(),
                  isActive: _currentStep >= 0,
                  state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: const Text('Payment'),
                  content: _buildPaymentStep(),
                  isActive: _currentStep >= 1,
                  state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: const Text('Review'),
                  content: _buildReviewStep(),
                  isActive: _currentStep >= 2,
                  state: _currentStep == 2 ? StepState.indexed : StepState.disabled,
                ),
              ],
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }
  
  Widget _buildShippingStep() {
    return Form(
      key: _shippingFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your address';
              }
              return null;
            },
          ),
          const SizedBox(height: AppTheme.spacingM),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(
                    labelText: 'State',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: TextFormField(
                  controller: _zipController,
                  decoration: const InputDecoration(
                    labelText: 'ZIP',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),
        ],
      ),
    );
  }
  
  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        Wrap(
          spacing: 8,
          children: _paymentMethods.map((method) {
            final isSelected = method == _selectedPaymentMethod;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPaymentMethod = method;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingS,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  border: Border.all(
                    color: isSelected ? AppTheme.primaryColor : AppTheme.lightGrey,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      color: isSelected ? AppTheme.primaryColor : AppTheme.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      method,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppTheme.spacingL),
        Form(
          key: _paymentFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  hintText: '1234 5678 9012 3456',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your card number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacingM),
              TextFormField(
                controller: _cardNameController,
                decoration: const InputDecoration(
                  labelText: 'Cardholder Name',
                  hintText: 'John Doe',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the cardholder name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacingM),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cardExpiryController,
                      decoration: const InputDecoration(
                        labelText: 'Expiry Date',
                        hintText: 'MM/YY',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: TextFormField(
                      controller: _cardCvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        hintText: '123',
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingL),
      ],
    );
  }
  
  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        ...widget.cart.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${item.quantity} x ${item.product.name}',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '\$${item.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )),
        const Divider(height: 24),
        _buildSummaryRow('Subtotal', '\$${widget.subtotal.toStringAsFixed(2)}'),
        _buildSummaryRow('Tax (8%)', '\$${widget.tax.toStringAsFixed(2)}'),
        _buildSummaryRow(
          'Shipping', 
          widget.shipping > 0 
              ? '\$${widget.shipping.toStringAsFixed(2)}' 
              : 'Free',
          widget.shipping > 0 ? null : AppTheme.successColor,
        ),
        const Divider(height: 24),
        _buildSummaryRow(
          'Total', 
          '\$${widget.total.toStringAsFixed(2)}',
          AppTheme.primaryColor,
          true,
        ),
        const SizedBox(height: AppTheme.spacingL),
        const Text(
          'Shipping Address',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppTheme.spacingS),
        Text('${_addressController.text}'),
        Text('${_cityController.text}, ${_stateController.text} ${_zipController.text}'),
        const SizedBox(height: AppTheme.spacingL),
        const Text(
          'Payment Method',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppTheme.spacingS),
        Text(_selectedPaymentMethod),
        const SizedBox(height: AppTheme.spacingL),
      ],
    );
  }
  
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppTheme.borderRadiusLarge),
          topRight: Radius.circular(AppTheme.borderRadiusLarge),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            onPressed: _cancelStep,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(120, 56),
            ),
            child: Text(_currentStep == 0 ? 'Cancel' : 'Back'),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: CustomButton(
              text: _currentStep == 2 ? 'Place Order' : 'Continue',
              isLoading: _isPlacingOrder,
              onPressed: _continueStep,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryRow(String label, String value, [Color? valueColor, bool isLarge = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isLarge
                ? const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )
                : TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
          ),
          Text(
            value,
            style: isLarge
                ? TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  )
                : TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: valueColor,
                  ),
          ),
        ],
      ),
    );
  }
}
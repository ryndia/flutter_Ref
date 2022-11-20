import 'package:flutter/material.dart';

class Home extends StatefulWidget
{
	@override
	_HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
{
	final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
	Order _order = Order("",0);

	@override

	Widget build(BuildContext context)
	{
		return Scaffold(
			body: SafeArea(
				child: Column(
					children: <Widget>[
						Form(
              				key: _formStateKey,
							autovalidateMode: AutovalidateMode.always,
							child: Padding(padding: EdgeInsets.all(16),
							child: Column(
								children: <Widget>[
										TextFormField(
	                    					decoration: const InputDecoration(
											hintText: "Cafe",
											labelText: 'Item',),
											validator: (value) => _validateItemRequired(value!),
											onSaved: (value) => _order.item = value!,
										),
										TextFormField(
	                    					decoration: const InputDecoration(
											hintText: '3',
											labelText: 'quantity',),
											validator: (value) => _validateItemCount(value!),
											onSaved: (value) => _order.quantity = int.tryParse(value!)!,
										),
										const Divider(),
										TextButton(
											child: const Text('save'),
											onPressed: () => _submitOrder(),
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
	String? _validateItemRequired(String value){
		return value.isEmpty? 'At least one Item': null;
	}

	String? _validateItemCount(String value)
	{
		var q = value.isEmpty? 0: int.tryParse(value);
		return q == 0?'At least one Item': null;
	}

	void _submitOrder()
	{
		if(_formStateKey.currentState!.validate())
		{
			_formStateKey.currentState!.save();
			print('Order item: $_order.item');
			print('Order Quantity: $_order.quantity');
		}
	}
}

class Order
{
	String item;
	int quantity;

	Order(this.item, this.quantity);
}

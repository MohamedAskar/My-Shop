import 'package:flutter/material.dart';

import 'dart:math';
import 'package:intl/intl.dart';
import 'package:shop/providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  final int orderNumber;

  OrderItem(this.order, this.orderNumber);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: expanded ? min(widget.order.products.length * 80.0 + 110, 400) : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ListTile(
              title: Text(
                'Order No.${widget.orderNumber}',
                style: TextStyle(
                    fontSize: expanded ? 14 : 20,
                    fontWeight: expanded ? FontWeight.w300 : FontWeight.bold),
              ),
              subtitle: expanded
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '\$${widget.order.totalPrice.toStringAsFixed(2)}  ',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Text(
                            '(Estimated VAT and Shipping Fees are NOT included)')
                      ],
                    )
                  : Text(
                      '${DateFormat('EEE, MMM dd').format(widget.order.dateTime)} at ${DateFormat('hh:mm').format(widget.order.dateTime)}'),
              trailing: IconButton(
                icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    expanded = !expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: expanded ? widget.order.products.length * 80.0 : 0,
              child: ListView.builder(
                itemCount: widget.order.products.length,
                itemBuilder: (ctx, i) => Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              widget.order.products[i].imageUrl,
                            ),
                            radius: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(widget.order.products[i].title,
                              style: TextStyle(
                                fontSize: 18,
                              )),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'x${widget.order.products[i].quantity} ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            '\$${widget.order.products[i].price.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

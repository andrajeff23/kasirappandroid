import 'package:dewakoding_kasir/app/data/source/order_api_service.dart';
import 'package:dewakoding_kasir/app/domain/entity/order.dart';
import 'package:dewakoding_kasir/app/domain/repository/order_repository.dart';
import 'package:dewakoding_kasir/core/network/data_state.dart';

class OrderRepositoryImpl extends OrderRepository {
  final OrderApiService _orderApiService;

  OrderRepositoryImpl(this._orderApiService);

  @override
  Future<DataState<List<OrderEntity>>> getAll() {
    return handleResponse(() => _orderApiService.getAll(), (json) {
      final list = (json as List);
      return List<OrderEntity>.from(list.map((item) {
        final normalized = _normalizeOrderJson(item);
        return OrderEntity.fromJson(normalized);
      }));
    });
  }

  @override
  Future<DataState<OrderEntity>> getById(int id) {
    return handleResponse(() => _orderApiService.getById(id: id), (json) {
      final normalized = _normalizeOrderJson(json);
      return OrderEntity.fromJson(normalized);
    });
  }

  @override
  Future<DataState<int>> insert(OrderEntity param) {
    return handleResponse(() => _orderApiService.insert(body: param.toJson()),
        (json) => json['id']);
  }

  @override
  Future<DataState> update(OrderEntity param) {
    return handleResponse(
        () => _orderApiService.update(id: param.id!, body: param.toJson()),
        (json) => null);
  }

  Map<String, dynamic> _normalizeOrderJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      final map = Map<String, dynamic>.from(json);

      if (map['order'] is Map<String, dynamic>) {
        final orderMap = Map<String, dynamic>.from(map['order'] as Map);
        map.addAll(orderMap);
        map.remove('order');
      }

      List<dynamic>? itemsJson;
      if (map['items'] is List) {
        itemsJson = map['items'] as List;
      } else if (map['order_items'] is List) {
        itemsJson = map['order_items'] as List;
      } else if (map['order_products'] is List) {
        itemsJson = map['order_products'] as List;
      } else if (map['orderDetails'] is List) {
        itemsJson = map['orderDetails'] as List;
      } else if (map['order_details'] is List) {
        itemsJson = map['order_details'] as List;
      } else if (map['details'] is List) {
        itemsJson = map['details'] as List;
      } else if (map['products'] is List) {
        itemsJson = map['products'] as List;
      }

      if (itemsJson != null) {
        map['items'] = itemsJson.map((e) {
          if (e is Map<String, dynamic>) {
            final item = Map<String, dynamic>.from(e);
            item.putIfAbsent('product_id', () => item['id'] ?? item['productId']);
            item.putIfAbsent('product_name', () => item['name'] ?? item['productName']);
            item.putIfAbsent('unit_price', () => item['price'] ?? item['unitPrice']);
            item.putIfAbsent('quantity', () => item['qty'] ?? item['quantity'] ?? 0);
            // keep barcode/stock if present
            return item;
          }
          return e;
        }).toList();
      }

      return map;
    }
    return {
      'items': <dynamic>[],
    };
  }
}

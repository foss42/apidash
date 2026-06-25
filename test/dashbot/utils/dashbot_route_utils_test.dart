import 'package:apidash/dashbot/routes/dashbot_routes.dart';
import 'package:apidash/dashbot/utils/dashbot_route_utils.dart';
import 'package:apidash/models/models.dart';
import 'package:better_networking/better_networking.dart';
import 'package:test/test.dart';

void main() {
  group('Dashbot Route Utils', () {
    test('computeDashbotBaseRoute returns home if has response status', () {
      final req = RequestModel(id: '1', responseStatus: 200);
      expect(computeDashbotBaseRoute(req), DashbotRoutes.dashbotHome);
    });

    test('computeDashbotBaseRoute returns home if has http response', () {
      final req = RequestModel(
        id: '1',
        httpResponseModel: HttpResponseModel(statusCode: 200),
      );
      expect(computeDashbotBaseRoute(req), DashbotRoutes.dashbotHome);
    });

    test('computeDashbotBaseRoute returns default if no response', () {
      final req = RequestModel(id: '1');
      expect(computeDashbotBaseRoute(req), DashbotRoutes.dashbotDefault);
    });

    test('computeDashbotBaseRoute returns default if req is null', () {
      expect(computeDashbotBaseRoute(null), DashbotRoutes.dashbotDefault);
    });

    test('needsDashbotRouteChange returns true when target differs', () {
      final req = RequestModel(id: '1', responseStatus: 200);
      expect(needsDashbotRouteChange(req, DashbotRoutes.dashbotDefault), true);
    });

    test('needsDashbotRouteChange returns false when target is same', () {
      final req = RequestModel(id: '1', responseStatus: 200);
      expect(needsDashbotRouteChange(req, DashbotRoutes.dashbotHome), false);
    });
  });
}

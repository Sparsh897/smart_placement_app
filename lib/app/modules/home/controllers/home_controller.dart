import 'package:get/get.dart';

import '../../../data/models/job_models.dart';
import '../../placement/controllers/placement_controller.dart';

class HomeController extends GetxController {
  final placementController = Get.find<PlacementController>();
  
  final selectedDomains = <String>[].obs;
  final searchQuery = ''.obs;
  final filteredJobs = <Job>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAllJobs();
  }

  void loadAllJobs() {
    print('🏠 [HOME] Loading all jobs from PlacementController');
    // Load jobs from PlacementController
    filteredJobs.value = placementController.displayJobs;
    print('🏠 [HOME] Loaded ${filteredJobs.length} jobs');
  }

  void toggleDomainFilter(String domain) {
    print('🏠 [HOME] Toggling domain filter: $domain');
    if (selectedDomains.contains(domain)) {
      selectedDomains.remove(domain);
      print('🏠 [HOME] Removed domain filter: $domain');
    } else {
      selectedDomains.add(domain);
      print('🏠 [HOME] Added domain filter: $domain');
    }
    print('🏠 [HOME] Active domain filters: ${selectedDomains.toList()}');
    applyFilters();
  }

  void setSearchQuery(String query) {
    print('🏠 [HOME] Setting search query: "$query"');
    searchQuery.value = query;
    applyFilters();
  }

  void applyFilters() {
    print('🏠 [HOME] Applying filters - Domains: ${selectedDomains.toList()}, Search: "${searchQuery.value}"');
    
    // Use PlacementController's filtering
    if (selectedDomains.isNotEmpty) {
      // Apply domain filter through PlacementController
      placementController.updateDomain(selectedDomains.first);
      print('🏠 [HOME] Applied domain filter: ${selectedDomains.first}');
    }
    
    if (searchQuery.value.isNotEmpty) {
      placementController.updateSearch(searchQuery.value);
      print('🏠 [HOME] Applied search filter: "${searchQuery.value}"');
    }
    
    filteredJobs.value = placementController.displayJobs;
    print('🏠 [HOME] Filtered jobs count: ${filteredJobs.length}');
  }

  void clearFilters() {
    print('🏠 [HOME] Clearing all filters');
    selectedDomains.clear();
    searchQuery.value = '';
    loadAllJobs();
    print('🏠 [HOME] All filters cleared');
  }

  List<String> get availableDomains {
    return placementController.allDomains;
  }
}

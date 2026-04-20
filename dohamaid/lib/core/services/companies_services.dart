
import '../../features/companies/companies_services/data/company_services_model.dart';
import '../../features/companies/company_details/data/company_detail_model.dart';
import '../../features/companies/worker_companies/data/worker_companies_model.dart';
import '../data/datasources/api_service.dart';
import '../utils/api_constant.dart';

class CompaniesServices {
  final ApiService api;
  CompaniesServices(this.api);

  Future<WorkerCompaniesModel?> getAllWorkerCompanies(int page) async {

    final resp = await api.get(ApiConstant.workerCompaniesLink,query: {
      "page":page,

    });
    final data = resp.data;
    if (data == null) return null;

    return WorkerCompaniesModel.fromJson(data);
  }
  Future<WorkerCompaniesModel?> getAllCleaningCompanies(int page) async {

    final resp = await api.get(ApiConstant.cleaningCompaniesLink,query: {
      "page":page,

    });
    final data = resp.data;
    if (data == null) return null;

    return WorkerCompaniesModel.fromJson(data);
  }
  Future<WorkerCompaniesModel?> getAllAntiBugCompanies(int page) async {

    final resp = await api.get(ApiConstant.antiBugCompaniesLink,query: {
      "page":page,

    });
    final data = resp.data;
    if (data == null) return null;

    return WorkerCompaniesModel.fromJson(data);
  }
  Future<WorkerCompaniesModel?> getAllNursingCompanies(int page) async {

    final resp = await api.get(ApiConstant.nursingCompaniesLink,query: {
      "page":page,

    });
    final data = resp.data;
    if (data == null) return null;

    return WorkerCompaniesModel.fromJson(data);
  }
  Future<WorkerCompaniesModel?> getAllWorkerSuppliers(int page) async {

    final resp = await api.get(ApiConstant.workerSuppliersLink,query: {
      "page":page,

    });
    final data = resp.data;
    if (data == null) return null;

    return WorkerCompaniesModel.fromJson(data);
  }
  Future<CompanyDetailsModel?> getCompanyDetails(int companyId) async {

    final resp = await api.get("${ApiConstant.companyDetailsLink}$companyId",);
    final data = resp.data;
    if (data == null) return null;

    return CompanyDetailsModel.fromJson(data);
  }
  Future<CompaniesServicesModel?> getCompaniesServices() async {

    final resp = await api.get(ApiConstant.companiesServicesLink,);
    final data = resp.data;
    if (data == null) return null;

    return CompaniesServicesModel.fromJson(data);
  }


}
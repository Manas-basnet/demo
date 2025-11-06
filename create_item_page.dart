import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfm/core/di/injection.dart';
import 'package:sfm/features/master/item/presentation/cubit/asset_account_item/asset_account_item_cubit.dart';
import 'package:sfm/features/master/item/presentation/cubit/brand_item/brand_item_cubit.dart';
import 'package:sfm/features/master/item/presentation/cubit/c_o_g_account_item/c_o_g_account_item_cubit.dart';
import 'package:sfm/features/master/item/presentation/cubit/category_item/category_item_cubit.dart';
import 'package:sfm/features/master/item/presentation/cubit/costing_method_item/costing_method_item_cubit.dart';
import 'package:sfm/features/master/item/presentation/cubit/expenses_account_item/expenses_account_item_cubit.dart';
import 'package:sfm/features/master/item/presentation/cubit/income_account_item/income_account_item_cubit.dart';
import 'package:sfm/features/master/item/presentation/cubit/item_type/item_type_cubit.dart';
import 'package:sfm/features/master/item/presentation/cubit/preferred_vendor_item/preferred_vendor_item_cubit.dart';
import 'package:sfm/features/master/item/presentation/cubit/sub_type_item/sub_type_item_cubit.dart';
import 'package:sfm/features/master/item/presentation/cubit/tax_item/tax_item_cubit.dart';
import 'package:sfm/features/master/item/presentation/cubit/unit_item/unit_item_cubit.dart';
import 'package:sfm/features/master/item/presentation/presentation.dart';

import '../cubit/parent_item/parent_item_cubit.dart';

class CreateItemPage extends StatefulWidget {
  const CreateItemPage({Key? key}) : super(key: key);

  @override
  State<CreateItemPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  final _formKey = GlobalKey<FormState>();

  final _hsCodeController = TextEditingController();
  final _itemCodeController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _purchaseRateController = TextEditingController();
  final _salesRateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _shelfLifeController = TextEditingController();
  final _warrantyController = TextEditingController();
  final _safetyStockController = TextEditingController();
  final _reorderPointController = TextEditingController();
  final _minOrderQtyController = TextEditingController();
  final _leadTimeController = TextEditingController();
  final _minSalesQtyController = TextEditingController();
  final _maxSalesQtyController = TextEditingController();

  int? _selectedStandardUnit;
  int? _selectedCategory;
  int? _selectedItemType;
  int? _selectedSubItemType;
  int? _selectedIncomeAccount;
  int? _selectedExpensesAccount;
  int? _selectedCogsAccount;
  int? _selectedAssetsAccount;
  int? _selectedValuationMethod;
  int? _selectedPreferredVendor;
  int? _selectedTaxCode;
  DateTime? _selectedEndOfLife;

  bool _maintainStock = false;
  bool _trackLandedCost = false;
  bool _inactive = false;
  bool _nonPosting = false;
  bool _hasSerialNos = false;
  bool _hasBatchNos = false;
  bool _allowNegativeStock = false;
  bool _defaultDiscount = false;

  List<UomEntry> _uomEntries = [];

  @override
  void dispose() {
    _hsCodeController.dispose();
    _itemCodeController.dispose();
    _itemNameController.dispose();
    _purchaseRateController.dispose();
    _salesRateController.dispose();
    _descriptionController.dispose();
    _shelfLifeController.dispose();
    _warrantyController.dispose();
    _safetyStockController.dispose();
    _reorderPointController.dispose();
    _minOrderQtyController.dispose();
    _leadTimeController.dispose();
    _minSalesQtyController.dispose();
    _maxSalesQtyController.dispose();
    for (var entry in _uomEntries) {
      entry.dispose();
    }
    super.dispose();
  }

  void _addUomEntry() {
    setState(() {
      _uomEntries.add(UomEntry());
    });
  }

  void _removeUomEntry(int index) {
    setState(() {
      _uomEntries[index].dispose();
      _uomEntries.removeAt(index);
    });
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {});

      // Simulate API call
      await Future<void>.delayed(const Duration(seconds: 2));

      setState(() {});

      // TODO: Implement actual save logic
      // After successful save, pop or show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item saved successfully')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<ParentItemCubit>()),
        BlocProvider(create: (context) => getIt<UnitItemCubit>()),
        BlocProvider(create: (context) => getIt<CategoryItemCubit>()),
        BlocProvider(create: (context) => getIt<BrandItemCubit>()),
        BlocProvider(create: (context) => getIt<ItemTypeCubit>()),
        BlocProvider(create: (context) => getIt<SubTypeItemCubit>()),
        BlocProvider(create: (context) => getIt<IncomeAccountItemCubit>()),
        BlocProvider(create: (context) => getIt<ExpensesAccountItemCubit>()),
        BlocProvider(create: (context) => getIt<COGAccountItemCubit>()),
        BlocProvider(create: (context) => getIt<AssetAccountItemCubit>()),
        BlocProvider(create: (context) => getIt<CostingMethodItemCubit>()),
        BlocProvider(create: (context) => getIt<PreferredVendorItemCubit>()),
        BlocProvider(create: (context) => getIt<TaxItemCubit>()),
      ],
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          title: Text(
            'Create Item',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          ),
          leading: BackButton(onPressed: () => Navigator.pop(context)),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormSection(
                        title: 'Details',
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: 'HS Code',
                                  controller: _hsCodeController,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Item Code',
                                  controller: _itemCodeController,
                                ),
                              ),
                            ],
                          ),
                          CustomTextField(
                            label: 'Item Name',
                            controller: _itemNameController,
                            required: true,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomCheckbox(
                                  label: 'Maintain Stock',
                                  value: _maintainStock,
                                  onChanged: (val) {
                                    setState(() => _maintainStock = val!);
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: BlocBuilder<ItemTypeCubit, ItemTypeState>(
                                  builder: (context, state) {
                                    return AutocompleteDropdown<int>(
                                      label: 'Item Type',
                                      items: state.maybeWhen(
                                        loading: () => [],
                                        loaded: (data) => data
                                            .map(
                                              (e) => (
                                                text: e.value ?? 'N/A',
                                                value: e.id ?? 0,
                                              ),
                                            )
                                            .toList(),
                                        orElse: () => [],
                                      ),
                                      value: _selectedItemType,
                                      onChanged: (val) {
                                        setState(() => _selectedItemType = val);
                                        log(val.toString());
                                      },
                                      isLoading: state.maybeWhen(
                                        loading: () => true,
                                        orElse: () => false,
                                      ),
                                      isError: state.maybeWhen(
                                        error: (err) => true,
                                        orElse: () => false
                                      ),
                                      onRetry: () {
                                        context.read<PreferredVendorItemCubit>().loadPreferredVendorItems();
                                      }
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: BlocBuilder<SubTypeItemCubit, SubTypeItemState>(
                                  builder: (context, state) {
                                    return AutocompleteDropdown<int>(
                                      label: 'Purpose',
                                      items: state.maybeWhen(
                                        loading: () => [],
                                        loaded: (data) => data
                                            .map(
                                              (e) => (
                                                text: e.value,
                                                value: e.id,
                                              ),
                                            )
                                            .toList(),
                                        orElse: () => [],
                                      ),
                                      value: _selectedSubItemType,
                                      onChanged: (val) {
                                        setState(() => _selectedSubItemType = val);
                                        log(val.toString());
                                      },
                                      isLoading: state.maybeWhen(
                                        loading: () => true,
                                        orElse: () => false,
                                      ),
                                      isError: state.maybeWhen(
                                        error: (err) => true,
                                        orElse: () => false
                                      ),
                                      onRetry: () {
                                        context.read<PreferredVendorItemCubit>().loadPreferredVendorItems();
                                      }
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child:
                                    BlocBuilder<UnitItemCubit, UnitItemState>(
                                      builder: (context, state) {
                                        return AutocompleteDropdown<int>(
                                          label: 'Standard Unit',
                                          items: state.maybeWhen(
                                            loading: () => [],
                                            loaded: (data) => data
                                                .map(
                                                  (e) => (
                                                    text: e.value ?? 'N/A',
                                                    value: e.id ?? 0,
                                                  ),
                                                )
                                                .toList(),
                                            orElse: () => [],
                                          ),
                                          value: _selectedStandardUnit,
                                          onChanged: (val) {
                                            setState(
                                              () => _selectedStandardUnit = val,
                                            );
                                            log(val.toString());
                                          },
                                          isLoading: state.maybeWhen(
                                            loading: () => true,
                                            orElse: () => false,
                                          ),
                                          isError: state.maybeWhen(
                                            error: (err) => true,
                                            orElse: () => false
                                          ),
                                          onRetry: () {
                                            context.read<PreferredVendorItemCubit>().loadPreferredVendorItems();
                                          }
                                        );
                                      },
                                    ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child:
                                    BlocBuilder<CategoryItemCubit,CategoryItemState>(
                                      builder: (context, state) {
                                        return AutocompleteDropdown<int>(
                                          label: 'Category',
                                          items: state.maybeWhen(
                                            loading: () => [],
                                            loaded: (data) => data
                                                .map(
                                                  (e) => (
                                                    text: e.value ?? 'N/A',
                                                    value: e.id ?? 0,
                                                  ),
                                                )
                                                .toList(),
                                            orElse: () => [],
                                          ),
                                          value: _selectedCategory,
                                          onChanged: (val) {
                                            setState(
                                              () => _selectedCategory = val,
                                            );
                                            log(val.toString());
                                          },
                                          isLoading: state.maybeWhen(
                                            loading: () => true,
                                            orElse: () => false,
                                          ),
                                          isError: state.maybeWhen(
                                            error: (err) => true,
                                            orElse: () => false
                                          ),
                                          onRetry: () {
                                            context.read<PreferredVendorItemCubit>().loadPreferredVendorItems();
                                          }
                                        );
                                      },
                                    ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: 'Purchase Rate',
                                  controller: _purchaseRateController,
                                  isNumber: true,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Sales Rate',
                                  controller: _salesRateController,
                                  isNumber: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomCheckbox(
                                  label: 'Track Landed Cost',
                                  value: _trackLandedCost,
                                  onChanged: (val) =>
                                      setState(() => _trackLandedCost = val!),
                                ),
                              ),
                              Expanded(
                                child: CustomCheckbox(
                                  label: 'Inactive',
                                  value: _inactive,
                                  onChanged: (val) =>
                                      setState(() => _inactive = val!),
                                ),
                              ),
                            ],
                          ),
                          BlocBuilder<TaxItemCubit, TaxItemState>(
                            builder: (context, state) {
                              return AutocompleteDropdown<int>(
                                label: 'Tax Code',
                                items: state.maybeWhen(
                                  loading: () => [],
                                  loaded: (data) => data
                                      .map(
                                        (e) => (
                                          text: e.value ?? 'N/A',
                                          value: e.id ?? 0,
                                        ),
                                      )
                                      .toList(),
                                  orElse: () => [],
                                ),
                                value: _selectedTaxCode,
                                onChanged: (val) {
                                  setState(
                                    () => _selectedTaxCode = val,
                                  );
                                  log(val.toString());
                                },
                                isLoading: state.maybeWhen(
                                  loading: () => true,
                                  orElse: () => false,
                                ),
                                isError: state.maybeWhen(
                                  error: (err) => true,
                                  orElse: () => false
                                ),
                                onRetry: () {
                                  context.read<PreferredVendorItemCubit>().loadPreferredVendorItems();
                                }
                              );
                            },
                          ),
                          CustomTextField(
                            label: 'Description',
                            controller: _descriptionController,
                            maxLines: 3,
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      FormSection(
                        title: 'Accounting',
                        children: [
                          BlocBuilder<IncomeAccountItemCubit,IncomeAccountItemState>(
                            builder: (context, state) {
                              return AutocompleteDropdown<int>(
                                label: 'Income Account',
                                items: state.maybeWhen(
                                  loading: () => [],
                                  loaded: (data) => data
                                      .map(
                                        (e) => (
                                          text: e.value ?? 'N/A',
                                          value: e.id ?? 0,
                                        ),
                                      )
                                      .toList(),
                                  orElse: () => [],
                                ),
                                value: _selectedIncomeAccount,
                                onChanged: (val) {
                                  setState(() => _selectedIncomeAccount = val);
                                  log(val.toString());
                                },
                                isLoading: state.maybeWhen(
                                  loading: () => true,
                                  orElse: () => false,
                                ),
                                isError: state.maybeWhen(
                                  error: (err) => true,
                                  orElse: () => false
                                ),
                                onRetry: () {
                                  context.read<PreferredVendorItemCubit>().loadPreferredVendorItems();
                                }
                              );
                            },
                          ),
                          BlocBuilder<ExpensesAccountItemCubit,ExpensesAccountItemState>(
                            builder: (context, state) {
                              return AutocompleteDropdown<int>(
                                label: 'Expenses Account',
                                items: state.maybeWhen(
                                  loading: () => [],
                                  loaded: (data) => data
                                      .map(
                                        (e) => (
                                          text: e.value ?? 'N/A',
                                          value: e.id ?? 0,
                                        ),
                                      )
                                      .toList(),
                                  orElse: () => [],
                                ),
                                value: _selectedExpensesAccount,
                                onChanged: (val) {
                                  setState(
                                    () => _selectedExpensesAccount = val,
                                  );
                                  log(val.toString());
                                },
                                isLoading: state.maybeWhen(
                                  loading: () => true,
                                  orElse: () => false,
                                ),
                                isError: state.maybeWhen(
                                  error: (err) => true,
                                  orElse: () => false
                                ),
                                onRetry: () {
                                  context.read<PreferredVendorItemCubit>().loadPreferredVendorItems();
                                }
                              );
                            },
                          ),
                          BlocBuilder<AssetAccountItemCubit,AssetAccountItemState>(
                            builder: (context, state) {
                              return AutocompleteDropdown<int>(
                                label: 'Assets Account',
                                items: state.maybeWhen(
                                  loading: () => [],
                                  loaded: (data) => data
                                      .map(
                                        (e) => (
                                          text: e.value ?? 'N/A',
                                          value: e.id ?? 0,
                                        ),
                                      )
                                      .toList(),
                                  orElse: () => [],
                                ),
                                value: _selectedAssetsAccount,
                                onChanged: (val) {
                                  setState(() => _selectedAssetsAccount = val);
                                  log(val.toString());
                                },
                                isLoading: state.maybeWhen(
                                  loading: () => true,
                                  orElse: () => false,
                                ),
                                isError: state.maybeWhen(
                                  error: (err) => true,
                                  orElse: () => false
                                ),
                                onRetry: () {
                                  context.read<PreferredVendorItemCubit>().loadPreferredVendorItems();
                                }
                              );
                            },
                          ),
                          BlocBuilder<COGAccountItemCubit, COGAccountItemState>(
                            builder: (context, state) {
                              return AutocompleteDropdown<int>(
                                label: 'COGS Account',
                                items: state.maybeWhen(
                                  loading: () => [],
                                  loaded: (data) => data
                                      .map(
                                        (e) => (
                                          text: e.value ?? 'N/A',
                                          value: e.id ?? 0,
                                        ),
                                      )
                                      .toList(),
                                  orElse: () => [],
                                ),
                                value: _selectedCogsAccount,
                                onChanged: (val) {
                                  setState(() => _selectedCogsAccount = val);
                                  log(val.toString());
                                },
                                isLoading: state.maybeWhen(
                                  loading: () => true,
                                  orElse: () => false,
                                ),
                                isError: state.maybeWhen(
                                  error: (err) => true,
                                  orElse: () => false
                                ),
                                onRetry: () {
                                  context.read<PreferredVendorItemCubit>().loadPreferredVendorItems();
                                }
                              );
                            },
                          ),
                          CustomCheckbox(
                            label: 'Non Posting',
                            value: _nonPosting,
                            onChanged: (val) =>
                                setState(() => _nonPosting = val!),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      FormSection(
                        title: 'Inventory',
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: 'Shelf Life in Days',
                                  controller: _shelfLifeController,
                                  isInteger: true,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Warranty Period',
                                  controller: _warrantyController,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomDatePicker(
                                  label: 'End of Life',
                                  date: _selectedEndOfLife,
                                  onChanged: (date) =>
                                      setState(() => _selectedEndOfLife = date),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child:
                                    BlocBuilder<CostingMethodItemCubit,CostingMethodItemState>(
                                      builder: (context, state) {
                                        return AutocompleteDropdown<int>(
                                          label: 'Valuation Method',
                                          items: state.maybeWhen(
                                            loading: () => [],
                                            loaded: (data) => data
                                                .map(
                                                  (e) => (
                                                    text: e.value,
                                                    value: e.id,
                                                  ),
                                                )
                                                .toList(),
                                            orElse: () => [],
                                          ),
                                          value: _selectedValuationMethod,
                                          onChanged: (val) {
                                            setState(
                                              () => _selectedValuationMethod =
                                                  val,
                                            );
                                            log(val.toString());
                                          },
                                          isLoading: state.maybeWhen(
                                            loading: () => true,
                                            orElse: () => false,
                                          ),
                                          isError: state.maybeWhen(
                                            error: (err) => true,
                                            orElse: () => false
                                          ),
                                          onRetry: () {
                                            context.read<PreferredVendorItemCubit>().loadPreferredVendorItems();
                                          }
                                        );
                                      },
                                    ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: 'Safety Stock',
                                  controller: _safetyStockController,
                                  isInteger: true,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Reorder Point',
                                  controller: _reorderPointController,
                                  isNumber: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomCheckbox(
                                  label: 'Has Serial Nos',
                                  value: _hasSerialNos,
                                  onChanged: (val) =>
                                      setState(() => _hasSerialNos = val!),
                                ),
                              ),
                              Expanded(
                                child: CustomCheckbox(
                                  label: 'Has Batch Nos',
                                  value: _hasBatchNos,
                                  onChanged: (val) =>
                                      setState(() => _hasBatchNos = val!),
                                ),
                              ),
                            ],
                          ),
                          CustomCheckbox(
                            label: 'Allow Negative Stock',
                            value: _allowNegativeStock,
                            onChanged: (val) =>
                                setState(() => _allowNegativeStock = val!),
                          ),
                          const SizedBox(height: 16),
                          _buildUomSection(),
                        ],
                      ),
                      const SizedBox(height: 40),
                      FormSection(
                        title: 'Purchase',
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: 'Minimum Order Quantity',
                                  controller: _minOrderQtyController,
                                  isNumber: true,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Lead Time',
                                  controller: _leadTimeController,
                                  isNumber: true,
                                ),
                              ),
                            ],
                          ),
                          BlocBuilder<PreferredVendorItemCubit,PreferredVendorItemState>(
                            builder: (context, state) {
                              return AutocompleteDropdown<int>(
                                label: 'Preferred Vendor',
                                items: state.maybeWhen(
                                  loading: () => [],
                                  loaded: (data) => data
                                      .map(
                                        (e) => (
                                          text: e.value ?? 'N/A',
                                          value: e.id ?? 0,
                                        ),
                                      )
                                      .toList(),
                                  orElse: () => [],
                                ),
                                value: _selectedPreferredVendor,
                                onChanged: (val) {
                                  setState(
                                    () => _selectedPreferredVendor = val,
                                  );
                                  log(val.toString());
                                },
                                isLoading: state.maybeWhen(
                                  loading: () => true,
                                  orElse: () => false,
                                ),
                                isError: state.maybeWhen(
                                  error: (err) => true,
                                  orElse: () => false
                                ),
                                onRetry: () {
                                  context.read<PreferredVendorItemCubit>().loadPreferredVendorItems();
                                }
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      FormSection(
                        title: 'Sales',
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomCheckbox(
                                  label: 'Default Discount',
                                  value: _defaultDiscount,
                                  onChanged: (val) =>
                                      setState(() => _defaultDiscount = val!),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: _handleSubmit,
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      disabledBackgroundColor: colorScheme.primary.withValues(
                        alpha: 0.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Save Item',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),

                    // _isLoading
                    //     ? SizedBox(
                    //         width: 20,
                    //         height: 20,
                    //         child: CircularProgressIndicator(
                    //           strokeWidth: 2,
                    //           valueColor: AlwaysStoppedAnimation<Color>(
                    //             colorScheme.onPrimary,
                    //           ),
                    //         ),
                    //       )
                    //     :
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUomSection() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Unit of Measure',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.1,
              ),
            ),
            OutlinedButton.icon(
              onPressed: _addUomEntry,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add UOM'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.primary,
                side: BorderSide(color: colorScheme.primary, width: 1.5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_uomEntries.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant, width: 0.1),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 32,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No UOM entries added',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _uomEntries.length,
            itemBuilder: (context, index) {
              return _buildUomEntry(index);
            },
          ),
      ],
    );
  }

  Widget _buildUomEntry(int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant, width: 0.1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: colorScheme.error,
                  size: 20,
                ),
                onPressed: () => _removeUomEntry(index),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _uomEntries[index].unitController,
                  decoration: InputDecoration(
                    labelText: 'Unit of Measure',
                    labelStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.3,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _uomEntries[index].conversionFactorController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Conversion Factor',
                    labelStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UomEntry {
  final TextEditingController unitController;
  final TextEditingController conversionFactorController;

  UomEntry()
    : unitController = TextEditingController(),
      conversionFactorController = TextEditingController();

  void dispose() {
    unitController.dispose();
    conversionFactorController.dispose();
  }
}

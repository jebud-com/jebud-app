// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_details_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetBudgetDetailsModelCollection on Isar {
  IsarCollection<BudgetDetailsModel> get budgetDetailsModels =>
      this.collection();
}

const BudgetDetailsModelSchema = CollectionSchema(
  name: r'BudgetDetailsModel',
  id: 6228741914252802389,
  properties: {
    r'startingAmount': PropertySchema(
      id: 0,
      name: r'startingAmount',
      type: IsarType.double,
    ),
    r'startingMonth': PropertySchema(
      id: 1,
      name: r'startingMonth',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _budgetDetailsModelEstimateSize,
  serialize: _budgetDetailsModelSerialize,
  deserialize: _budgetDetailsModelDeserialize,
  deserializeProp: _budgetDetailsModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _budgetDetailsModelGetId,
  getLinks: _budgetDetailsModelGetLinks,
  attach: _budgetDetailsModelAttach,
  version: '3.0.5',
);

int _budgetDetailsModelEstimateSize(
  BudgetDetailsModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _budgetDetailsModelSerialize(
  BudgetDetailsModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.startingAmount);
  writer.writeDateTime(offsets[1], object.startingMonth);
}

BudgetDetailsModel _budgetDetailsModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BudgetDetailsModel(
    startingAmount: reader.readDouble(offsets[0]),
    startingMonth: reader.readDateTime(offsets[1]),
  );
  object.id = id;
  return object;
}

P _budgetDetailsModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _budgetDetailsModelGetId(BudgetDetailsModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _budgetDetailsModelGetLinks(
    BudgetDetailsModel object) {
  return [];
}

void _budgetDetailsModelAttach(
    IsarCollection<dynamic> col, Id id, BudgetDetailsModel object) {
  object.id = id;
}

extension BudgetDetailsModelQueryWhereSort
    on QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QWhere> {
  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BudgetDetailsModelQueryWhere
    on QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QWhereClause> {
  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BudgetDetailsModelQueryFilter
    on QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QFilterCondition> {
  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterFilterCondition>
      startingAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startingAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterFilterCondition>
      startingAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startingAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterFilterCondition>
      startingAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startingAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterFilterCondition>
      startingAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startingAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterFilterCondition>
      startingMonthEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startingMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterFilterCondition>
      startingMonthGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startingMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterFilterCondition>
      startingMonthLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startingMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterFilterCondition>
      startingMonthBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startingMonth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BudgetDetailsModelQueryObject
    on QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QFilterCondition> {}

extension BudgetDetailsModelQueryLinks
    on QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QFilterCondition> {}

extension BudgetDetailsModelQuerySortBy
    on QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QSortBy> {
  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterSortBy>
      sortByStartingAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingAmount', Sort.asc);
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterSortBy>
      sortByStartingAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingAmount', Sort.desc);
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterSortBy>
      sortByStartingMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingMonth', Sort.asc);
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterSortBy>
      sortByStartingMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingMonth', Sort.desc);
    });
  }
}

extension BudgetDetailsModelQuerySortThenBy
    on QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QSortThenBy> {
  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterSortBy>
      thenByStartingAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingAmount', Sort.asc);
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterSortBy>
      thenByStartingAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingAmount', Sort.desc);
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterSortBy>
      thenByStartingMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingMonth', Sort.asc);
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QAfterSortBy>
      thenByStartingMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingMonth', Sort.desc);
    });
  }
}

extension BudgetDetailsModelQueryWhereDistinct
    on QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QDistinct> {
  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QDistinct>
      distinctByStartingAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startingAmount');
    });
  }

  QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QDistinct>
      distinctByStartingMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startingMonth');
    });
  }
}

extension BudgetDetailsModelQueryProperty
    on QueryBuilder<BudgetDetailsModel, BudgetDetailsModel, QQueryProperty> {
  QueryBuilder<BudgetDetailsModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BudgetDetailsModel, double, QQueryOperations>
      startingAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startingAmount');
    });
  }

  QueryBuilder<BudgetDetailsModel, DateTime, QQueryOperations>
      startingMonthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startingMonth');
    });
  }
}

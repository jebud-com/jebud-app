// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_expense_period_allocation_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetDailyExpensePeriodAllocationModelCollection on Isar {
  IsarCollection<DailyExpensePeriodAllocationModel>
      get dailyExpensePeriodAllocationModels => this.collection();
}

const DailyExpensePeriodAllocationModelSchema = CollectionSchema(
  name: r'DailyExpensePeriodAllocationModel',
  id: -1116149814789418401,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.double,
    )
  },
  estimateSize: _dailyExpensePeriodAllocationModelEstimateSize,
  serialize: _dailyExpensePeriodAllocationModelSerialize,
  deserialize: _dailyExpensePeriodAllocationModelDeserialize,
  deserializeProp: _dailyExpensePeriodAllocationModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _dailyExpensePeriodAllocationModelGetId,
  getLinks: _dailyExpensePeriodAllocationModelGetLinks,
  attach: _dailyExpensePeriodAllocationModelAttach,
  version: '3.0.5',
);

int _dailyExpensePeriodAllocationModelEstimateSize(
  DailyExpensePeriodAllocationModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _dailyExpensePeriodAllocationModelSerialize(
  DailyExpensePeriodAllocationModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
}

DailyExpensePeriodAllocationModel _dailyExpensePeriodAllocationModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyExpensePeriodAllocationModel(
    amount: reader.readDouble(offsets[0]),
  );
  object.id = id;
  return object;
}

P _dailyExpensePeriodAllocationModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyExpensePeriodAllocationModelGetId(
    DailyExpensePeriodAllocationModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyExpensePeriodAllocationModelGetLinks(
    DailyExpensePeriodAllocationModel object) {
  return [];
}

void _dailyExpensePeriodAllocationModelAttach(IsarCollection<dynamic> col,
    Id id, DailyExpensePeriodAllocationModel object) {
  object.id = id;
}

extension DailyExpensePeriodAllocationModelQueryWhereSort on QueryBuilder<
    DailyExpensePeriodAllocationModel,
    DailyExpensePeriodAllocationModel,
    QWhere> {
  QueryBuilder<DailyExpensePeriodAllocationModel,
      DailyExpensePeriodAllocationModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DailyExpensePeriodAllocationModelQueryWhere on QueryBuilder<
    DailyExpensePeriodAllocationModel,
    DailyExpensePeriodAllocationModel,
    QWhereClause> {
  QueryBuilder<DailyExpensePeriodAllocationModel,
      DailyExpensePeriodAllocationModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<
      DailyExpensePeriodAllocationModel,
      DailyExpensePeriodAllocationModel,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<
      DailyExpensePeriodAllocationModel,
      DailyExpensePeriodAllocationModel,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
      DailyExpensePeriodAllocationModel,
      DailyExpensePeriodAllocationModel,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyExpensePeriodAllocationModel,
      DailyExpensePeriodAllocationModel, QAfterWhereClause> idBetween(
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

extension DailyExpensePeriodAllocationModelQueryFilter on QueryBuilder<
    DailyExpensePeriodAllocationModel,
    DailyExpensePeriodAllocationModel,
    QFilterCondition> {
  QueryBuilder<DailyExpensePeriodAllocationModel,
      DailyExpensePeriodAllocationModel, QAfterFilterCondition> amountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<
      DailyExpensePeriodAllocationModel,
      DailyExpensePeriodAllocationModel,
      QAfterFilterCondition> amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyExpensePeriodAllocationModel,
      DailyExpensePeriodAllocationModel, QAfterFilterCondition> amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyExpensePeriodAllocationModel,
      DailyExpensePeriodAllocationModel, QAfterFilterCondition> amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<
      DailyExpensePeriodAllocationModel,
      DailyExpensePeriodAllocationModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyExpensePeriodAllocationModel,
      DailyExpensePeriodAllocationModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DailyExpensePeriodAllocationModel,
      DailyExpensePeriodAllocationModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DailyExpensePeriodAllocationModel,
      DailyExpensePeriodAllocationModel, QAfterFilterCondition> idBetween(
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
}

extension DailyExpensePeriodAllocationModelQueryObject on QueryBuilder<
    DailyExpensePeriodAllocationModel,
    DailyExpensePeriodAllocationModel,
    QFilterCondition> {}

extension DailyExpensePeriodAllocationModelQueryLinks on QueryBuilder<
    DailyExpensePeriodAllocationModel,
    DailyExpensePeriodAllocationModel,
    QFilterCondition> {}

extension DailyExpensePeriodAllocationModelQuerySortBy on QueryBuilder<
    DailyExpensePeriodAllocationModel,
    DailyExpensePeriodAllocationModel,
    QSortBy> {
  QueryBuilder<DailyExpensePeriodAllocationModel,
      DailyExpensePeriodAllocationModel, QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<DailyExpensePeriodAllocationModel,
      DailyExpensePeriodAllocationModel, QAfterSortBy> sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }
}

extension DailyExpensePeriodAllocationModelQuerySortThenBy on QueryBuilder<
    DailyExpensePeriodAllocationModel,
    DailyExpensePeriodAllocationModel,
    QSortThenBy> {
  QueryBuilder<DailyExpensePeriodAllocationModel,
      DailyExpensePeriodAllocationModel, QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<DailyExpensePeriodAllocationModel,
      DailyExpensePeriodAllocationModel, QAfterSortBy> thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<DailyExpensePeriodAllocationModel,
      DailyExpensePeriodAllocationModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyExpensePeriodAllocationModel,
      DailyExpensePeriodAllocationModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension DailyExpensePeriodAllocationModelQueryWhereDistinct on QueryBuilder<
    DailyExpensePeriodAllocationModel,
    DailyExpensePeriodAllocationModel,
    QDistinct> {
  QueryBuilder<DailyExpensePeriodAllocationModel,
      DailyExpensePeriodAllocationModel, QDistinct> distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }
}

extension DailyExpensePeriodAllocationModelQueryProperty on QueryBuilder<
    DailyExpensePeriodAllocationModel,
    DailyExpensePeriodAllocationModel,
    QQueryProperty> {
  QueryBuilder<DailyExpensePeriodAllocationModel, int, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyExpensePeriodAllocationModel, double, QQueryOperations>
      amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }
}

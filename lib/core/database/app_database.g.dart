// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CreditCardsTable extends CreditCards
    with TableInfo<$CreditCardsTable, CreditCardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreditCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _closingDayMeta = const VerificationMeta(
    'closingDay',
  );
  @override
  late final GeneratedColumn<int> closingDay = GeneratedColumn<int>(
    'closing_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDayMeta = const VerificationMeta('dueDay');
  @override
  late final GeneratedColumn<int> dueDay = GeneratedColumn<int>(
    'due_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _limitCentsMeta = const VerificationMeta(
    'limitCents',
  );
  @override
  late final GeneratedColumn<int> limitCents = GeneratedColumn<int>(
    'limit_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    closingDay,
    dueDay,
    limitCents,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credit_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<CreditCardRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('closing_day')) {
      context.handle(
        _closingDayMeta,
        closingDay.isAcceptableOrUnknown(data['closing_day']!, _closingDayMeta),
      );
    } else if (isInserting) {
      context.missing(_closingDayMeta);
    }
    if (data.containsKey('due_day')) {
      context.handle(
        _dueDayMeta,
        dueDay.isAcceptableOrUnknown(data['due_day']!, _dueDayMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDayMeta);
    }
    if (data.containsKey('limit_cents')) {
      context.handle(
        _limitCentsMeta,
        limitCents.isAcceptableOrUnknown(data['limit_cents']!, _limitCentsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CreditCardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreditCardRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      closingDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}closing_day'],
      )!,
      dueDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_day'],
      )!,
      limitCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}limit_cents'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CreditCardsTable createAlias(String alias) {
    return $CreditCardsTable(attachedDatabase, alias);
  }
}

class CreditCardRow extends DataClass implements Insertable<CreditCardRow> {
  final int id;
  final String name;

  /// Melhor dia de compra (dia de fechamento).
  final int closingDay;
  final int dueDay;
  final int? limitCents;
  final DateTime createdAt;
  const CreditCardRow({
    required this.id,
    required this.name,
    required this.closingDay,
    required this.dueDay,
    this.limitCents,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['closing_day'] = Variable<int>(closingDay);
    map['due_day'] = Variable<int>(dueDay);
    if (!nullToAbsent || limitCents != null) {
      map['limit_cents'] = Variable<int>(limitCents);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CreditCardsCompanion toCompanion(bool nullToAbsent) {
    return CreditCardsCompanion(
      id: Value(id),
      name: Value(name),
      closingDay: Value(closingDay),
      dueDay: Value(dueDay),
      limitCents: limitCents == null && nullToAbsent
          ? const Value.absent()
          : Value(limitCents),
      createdAt: Value(createdAt),
    );
  }

  factory CreditCardRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreditCardRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      closingDay: serializer.fromJson<int>(json['closingDay']),
      dueDay: serializer.fromJson<int>(json['dueDay']),
      limitCents: serializer.fromJson<int?>(json['limitCents']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'closingDay': serializer.toJson<int>(closingDay),
      'dueDay': serializer.toJson<int>(dueDay),
      'limitCents': serializer.toJson<int?>(limitCents),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CreditCardRow copyWith({
    int? id,
    String? name,
    int? closingDay,
    int? dueDay,
    Value<int?> limitCents = const Value.absent(),
    DateTime? createdAt,
  }) => CreditCardRow(
    id: id ?? this.id,
    name: name ?? this.name,
    closingDay: closingDay ?? this.closingDay,
    dueDay: dueDay ?? this.dueDay,
    limitCents: limitCents.present ? limitCents.value : this.limitCents,
    createdAt: createdAt ?? this.createdAt,
  );
  CreditCardRow copyWithCompanion(CreditCardsCompanion data) {
    return CreditCardRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      closingDay: data.closingDay.present
          ? data.closingDay.value
          : this.closingDay,
      dueDay: data.dueDay.present ? data.dueDay.value : this.dueDay,
      limitCents: data.limitCents.present
          ? data.limitCents.value
          : this.limitCents,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreditCardRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('closingDay: $closingDay, ')
          ..write('dueDay: $dueDay, ')
          ..write('limitCents: $limitCents, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, closingDay, dueDay, limitCents, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreditCardRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.closingDay == this.closingDay &&
          other.dueDay == this.dueDay &&
          other.limitCents == this.limitCents &&
          other.createdAt == this.createdAt);
}

class CreditCardsCompanion extends UpdateCompanion<CreditCardRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> closingDay;
  final Value<int> dueDay;
  final Value<int?> limitCents;
  final Value<DateTime> createdAt;
  const CreditCardsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.closingDay = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.limitCents = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CreditCardsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int closingDay,
    required int dueDay,
    this.limitCents = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       closingDay = Value(closingDay),
       dueDay = Value(dueDay);
  static Insertable<CreditCardRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? closingDay,
    Expression<int>? dueDay,
    Expression<int>? limitCents,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (closingDay != null) 'closing_day': closingDay,
      if (dueDay != null) 'due_day': dueDay,
      if (limitCents != null) 'limit_cents': limitCents,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CreditCardsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? closingDay,
    Value<int>? dueDay,
    Value<int?>? limitCents,
    Value<DateTime>? createdAt,
  }) {
    return CreditCardsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      closingDay: closingDay ?? this.closingDay,
      dueDay: dueDay ?? this.dueDay,
      limitCents: limitCents ?? this.limitCents,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (closingDay.present) {
      map['closing_day'] = Variable<int>(closingDay.value);
    }
    if (dueDay.present) {
      map['due_day'] = Variable<int>(dueDay.value);
    }
    if (limitCents.present) {
      map['limit_cents'] = Variable<int>(limitCents.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreditCardsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('closingDay: $closingDay, ')
          ..write('dueDay: $dueDay, ')
          ..write('limitCents: $limitCents, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $IncomesTable extends Incomes with TableInfo<$IncomesTable, IncomeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncomesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayOfMonthMeta = const VerificationMeta(
    'dayOfMonth',
  );
  @override
  late final GeneratedColumn<int> dayOfMonth = GeneratedColumn<int>(
    'day_of_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _startMonthMeta = const VerificationMeta(
    'startMonth',
  );
  @override
  late final GeneratedColumn<int> startMonth = GeneratedColumn<int>(
    'start_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    description,
    amountCents,
    dayOfMonth,
    active,
    startMonth,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'incomes';
  @override
  VerificationContext validateIntegrity(
    Insertable<IncomeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('day_of_month')) {
      context.handle(
        _dayOfMonthMeta,
        dayOfMonth.isAcceptableOrUnknown(
          data['day_of_month']!,
          _dayOfMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dayOfMonthMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('start_month')) {
      context.handle(
        _startMonthMeta,
        startMonth.isAcceptableOrUnknown(data['start_month']!, _startMonthMeta),
      );
    } else if (isInserting) {
      context.missing(_startMonthMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IncomeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncomeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      dayOfMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_month'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      startMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_month'],
      )!,
    );
  }

  @override
  $IncomesTable createAlias(String alias) {
    return $IncomesTable(attachedDatabase, alias);
  }
}

class IncomeRow extends DataClass implements Insertable<IncomeRow> {
  final int id;
  final String description;
  final int amountCents;
  final int dayOfMonth;
  final bool active;

  /// Primeiro mês (`yyyymm`) em que a receita vale.
  final int startMonth;
  const IncomeRow({
    required this.id,
    required this.description,
    required this.amountCents,
    required this.dayOfMonth,
    required this.active,
    required this.startMonth,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['description'] = Variable<String>(description);
    map['amount_cents'] = Variable<int>(amountCents);
    map['day_of_month'] = Variable<int>(dayOfMonth);
    map['active'] = Variable<bool>(active);
    map['start_month'] = Variable<int>(startMonth);
    return map;
  }

  IncomesCompanion toCompanion(bool nullToAbsent) {
    return IncomesCompanion(
      id: Value(id),
      description: Value(description),
      amountCents: Value(amountCents),
      dayOfMonth: Value(dayOfMonth),
      active: Value(active),
      startMonth: Value(startMonth),
    );
  }

  factory IncomeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncomeRow(
      id: serializer.fromJson<int>(json['id']),
      description: serializer.fromJson<String>(json['description']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      dayOfMonth: serializer.fromJson<int>(json['dayOfMonth']),
      active: serializer.fromJson<bool>(json['active']),
      startMonth: serializer.fromJson<int>(json['startMonth']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'description': serializer.toJson<String>(description),
      'amountCents': serializer.toJson<int>(amountCents),
      'dayOfMonth': serializer.toJson<int>(dayOfMonth),
      'active': serializer.toJson<bool>(active),
      'startMonth': serializer.toJson<int>(startMonth),
    };
  }

  IncomeRow copyWith({
    int? id,
    String? description,
    int? amountCents,
    int? dayOfMonth,
    bool? active,
    int? startMonth,
  }) => IncomeRow(
    id: id ?? this.id,
    description: description ?? this.description,
    amountCents: amountCents ?? this.amountCents,
    dayOfMonth: dayOfMonth ?? this.dayOfMonth,
    active: active ?? this.active,
    startMonth: startMonth ?? this.startMonth,
  );
  IncomeRow copyWithCompanion(IncomesCompanion data) {
    return IncomeRow(
      id: data.id.present ? data.id.value : this.id,
      description: data.description.present
          ? data.description.value
          : this.description,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      dayOfMonth: data.dayOfMonth.present
          ? data.dayOfMonth.value
          : this.dayOfMonth,
      active: data.active.present ? data.active.value : this.active,
      startMonth: data.startMonth.present
          ? data.startMonth.value
          : this.startMonth,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncomeRow(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('amountCents: $amountCents, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('active: $active, ')
          ..write('startMonth: $startMonth')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, description, amountCents, dayOfMonth, active, startMonth);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncomeRow &&
          other.id == this.id &&
          other.description == this.description &&
          other.amountCents == this.amountCents &&
          other.dayOfMonth == this.dayOfMonth &&
          other.active == this.active &&
          other.startMonth == this.startMonth);
}

class IncomesCompanion extends UpdateCompanion<IncomeRow> {
  final Value<int> id;
  final Value<String> description;
  final Value<int> amountCents;
  final Value<int> dayOfMonth;
  final Value<bool> active;
  final Value<int> startMonth;
  const IncomesCompanion({
    this.id = const Value.absent(),
    this.description = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.dayOfMonth = const Value.absent(),
    this.active = const Value.absent(),
    this.startMonth = const Value.absent(),
  });
  IncomesCompanion.insert({
    this.id = const Value.absent(),
    required String description,
    required int amountCents,
    required int dayOfMonth,
    this.active = const Value.absent(),
    required int startMonth,
  }) : description = Value(description),
       amountCents = Value(amountCents),
       dayOfMonth = Value(dayOfMonth),
       startMonth = Value(startMonth);
  static Insertable<IncomeRow> custom({
    Expression<int>? id,
    Expression<String>? description,
    Expression<int>? amountCents,
    Expression<int>? dayOfMonth,
    Expression<bool>? active,
    Expression<int>? startMonth,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (description != null) 'description': description,
      if (amountCents != null) 'amount_cents': amountCents,
      if (dayOfMonth != null) 'day_of_month': dayOfMonth,
      if (active != null) 'active': active,
      if (startMonth != null) 'start_month': startMonth,
    });
  }

  IncomesCompanion copyWith({
    Value<int>? id,
    Value<String>? description,
    Value<int>? amountCents,
    Value<int>? dayOfMonth,
    Value<bool>? active,
    Value<int>? startMonth,
  }) {
    return IncomesCompanion(
      id: id ?? this.id,
      description: description ?? this.description,
      amountCents: amountCents ?? this.amountCents,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      active: active ?? this.active,
      startMonth: startMonth ?? this.startMonth,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (dayOfMonth.present) {
      map['day_of_month'] = Variable<int>(dayOfMonth.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (startMonth.present) {
      map['start_month'] = Variable<int>(startMonth.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncomesCompanion(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('amountCents: $amountCents, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('active: $active, ')
          ..write('startMonth: $startMonth')
          ..write(')'))
        .toString();
  }
}

class $FixedExpensesTable extends FixedExpenses
    with TableInfo<$FixedExpensesTable, FixedExpenseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FixedExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultAmountCentsMeta =
      const VerificationMeta('defaultAmountCents');
  @override
  late final GeneratedColumn<int> defaultAmountCents = GeneratedColumn<int>(
    'default_amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDayMeta = const VerificationMeta('dueDay');
  @override
  late final GeneratedColumn<int> dueDay = GeneratedColumn<int>(
    'due_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _creditCardIdMeta = const VerificationMeta(
    'creditCardId',
  );
  @override
  late final GeneratedColumn<int> creditCardId = GeneratedColumn<int>(
    'credit_card_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES credit_cards (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _startMonthMeta = const VerificationMeta(
    'startMonth',
  );
  @override
  late final GeneratedColumn<int> startMonth = GeneratedColumn<int>(
    'start_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    description,
    defaultAmountCents,
    dueDay,
    active,
    creditCardId,
    startMonth,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fixed_expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<FixedExpenseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('default_amount_cents')) {
      context.handle(
        _defaultAmountCentsMeta,
        defaultAmountCents.isAcceptableOrUnknown(
          data['default_amount_cents']!,
          _defaultAmountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultAmountCentsMeta);
    }
    if (data.containsKey('due_day')) {
      context.handle(
        _dueDayMeta,
        dueDay.isAcceptableOrUnknown(data['due_day']!, _dueDayMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDayMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('credit_card_id')) {
      context.handle(
        _creditCardIdMeta,
        creditCardId.isAcceptableOrUnknown(
          data['credit_card_id']!,
          _creditCardIdMeta,
        ),
      );
    }
    if (data.containsKey('start_month')) {
      context.handle(
        _startMonthMeta,
        startMonth.isAcceptableOrUnknown(data['start_month']!, _startMonthMeta),
      );
    } else if (isInserting) {
      context.missing(_startMonthMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FixedExpenseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FixedExpenseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      defaultAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_amount_cents'],
      )!,
      dueDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_day'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      creditCardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credit_card_id'],
      ),
      startMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_month'],
      )!,
    );
  }

  @override
  $FixedExpensesTable createAlias(String alias) {
    return $FixedExpensesTable(attachedDatabase, alias);
  }
}

class FixedExpenseRow extends DataClass implements Insertable<FixedExpenseRow> {
  final int id;
  final String description;
  final int defaultAmountCents;
  final int dueDay;
  final bool active;

  /// Quando preenchido, a despesa entra na fatura deste cartão.
  final int? creditCardId;

  /// Primeiro mês (`yyyymm`) em que a despesa vale.
  final int startMonth;
  const FixedExpenseRow({
    required this.id,
    required this.description,
    required this.defaultAmountCents,
    required this.dueDay,
    required this.active,
    this.creditCardId,
    required this.startMonth,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['description'] = Variable<String>(description);
    map['default_amount_cents'] = Variable<int>(defaultAmountCents);
    map['due_day'] = Variable<int>(dueDay);
    map['active'] = Variable<bool>(active);
    if (!nullToAbsent || creditCardId != null) {
      map['credit_card_id'] = Variable<int>(creditCardId);
    }
    map['start_month'] = Variable<int>(startMonth);
    return map;
  }

  FixedExpensesCompanion toCompanion(bool nullToAbsent) {
    return FixedExpensesCompanion(
      id: Value(id),
      description: Value(description),
      defaultAmountCents: Value(defaultAmountCents),
      dueDay: Value(dueDay),
      active: Value(active),
      creditCardId: creditCardId == null && nullToAbsent
          ? const Value.absent()
          : Value(creditCardId),
      startMonth: Value(startMonth),
    );
  }

  factory FixedExpenseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FixedExpenseRow(
      id: serializer.fromJson<int>(json['id']),
      description: serializer.fromJson<String>(json['description']),
      defaultAmountCents: serializer.fromJson<int>(json['defaultAmountCents']),
      dueDay: serializer.fromJson<int>(json['dueDay']),
      active: serializer.fromJson<bool>(json['active']),
      creditCardId: serializer.fromJson<int?>(json['creditCardId']),
      startMonth: serializer.fromJson<int>(json['startMonth']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'description': serializer.toJson<String>(description),
      'defaultAmountCents': serializer.toJson<int>(defaultAmountCents),
      'dueDay': serializer.toJson<int>(dueDay),
      'active': serializer.toJson<bool>(active),
      'creditCardId': serializer.toJson<int?>(creditCardId),
      'startMonth': serializer.toJson<int>(startMonth),
    };
  }

  FixedExpenseRow copyWith({
    int? id,
    String? description,
    int? defaultAmountCents,
    int? dueDay,
    bool? active,
    Value<int?> creditCardId = const Value.absent(),
    int? startMonth,
  }) => FixedExpenseRow(
    id: id ?? this.id,
    description: description ?? this.description,
    defaultAmountCents: defaultAmountCents ?? this.defaultAmountCents,
    dueDay: dueDay ?? this.dueDay,
    active: active ?? this.active,
    creditCardId: creditCardId.present ? creditCardId.value : this.creditCardId,
    startMonth: startMonth ?? this.startMonth,
  );
  FixedExpenseRow copyWithCompanion(FixedExpensesCompanion data) {
    return FixedExpenseRow(
      id: data.id.present ? data.id.value : this.id,
      description: data.description.present
          ? data.description.value
          : this.description,
      defaultAmountCents: data.defaultAmountCents.present
          ? data.defaultAmountCents.value
          : this.defaultAmountCents,
      dueDay: data.dueDay.present ? data.dueDay.value : this.dueDay,
      active: data.active.present ? data.active.value : this.active,
      creditCardId: data.creditCardId.present
          ? data.creditCardId.value
          : this.creditCardId,
      startMonth: data.startMonth.present
          ? data.startMonth.value
          : this.startMonth,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FixedExpenseRow(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('defaultAmountCents: $defaultAmountCents, ')
          ..write('dueDay: $dueDay, ')
          ..write('active: $active, ')
          ..write('creditCardId: $creditCardId, ')
          ..write('startMonth: $startMonth')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    description,
    defaultAmountCents,
    dueDay,
    active,
    creditCardId,
    startMonth,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FixedExpenseRow &&
          other.id == this.id &&
          other.description == this.description &&
          other.defaultAmountCents == this.defaultAmountCents &&
          other.dueDay == this.dueDay &&
          other.active == this.active &&
          other.creditCardId == this.creditCardId &&
          other.startMonth == this.startMonth);
}

class FixedExpensesCompanion extends UpdateCompanion<FixedExpenseRow> {
  final Value<int> id;
  final Value<String> description;
  final Value<int> defaultAmountCents;
  final Value<int> dueDay;
  final Value<bool> active;
  final Value<int?> creditCardId;
  final Value<int> startMonth;
  const FixedExpensesCompanion({
    this.id = const Value.absent(),
    this.description = const Value.absent(),
    this.defaultAmountCents = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.active = const Value.absent(),
    this.creditCardId = const Value.absent(),
    this.startMonth = const Value.absent(),
  });
  FixedExpensesCompanion.insert({
    this.id = const Value.absent(),
    required String description,
    required int defaultAmountCents,
    required int dueDay,
    this.active = const Value.absent(),
    this.creditCardId = const Value.absent(),
    required int startMonth,
  }) : description = Value(description),
       defaultAmountCents = Value(defaultAmountCents),
       dueDay = Value(dueDay),
       startMonth = Value(startMonth);
  static Insertable<FixedExpenseRow> custom({
    Expression<int>? id,
    Expression<String>? description,
    Expression<int>? defaultAmountCents,
    Expression<int>? dueDay,
    Expression<bool>? active,
    Expression<int>? creditCardId,
    Expression<int>? startMonth,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (description != null) 'description': description,
      if (defaultAmountCents != null)
        'default_amount_cents': defaultAmountCents,
      if (dueDay != null) 'due_day': dueDay,
      if (active != null) 'active': active,
      if (creditCardId != null) 'credit_card_id': creditCardId,
      if (startMonth != null) 'start_month': startMonth,
    });
  }

  FixedExpensesCompanion copyWith({
    Value<int>? id,
    Value<String>? description,
    Value<int>? defaultAmountCents,
    Value<int>? dueDay,
    Value<bool>? active,
    Value<int?>? creditCardId,
    Value<int>? startMonth,
  }) {
    return FixedExpensesCompanion(
      id: id ?? this.id,
      description: description ?? this.description,
      defaultAmountCents: defaultAmountCents ?? this.defaultAmountCents,
      dueDay: dueDay ?? this.dueDay,
      active: active ?? this.active,
      creditCardId: creditCardId ?? this.creditCardId,
      startMonth: startMonth ?? this.startMonth,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (defaultAmountCents.present) {
      map['default_amount_cents'] = Variable<int>(defaultAmountCents.value);
    }
    if (dueDay.present) {
      map['due_day'] = Variable<int>(dueDay.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (creditCardId.present) {
      map['credit_card_id'] = Variable<int>(creditCardId.value);
    }
    if (startMonth.present) {
      map['start_month'] = Variable<int>(startMonth.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FixedExpensesCompanion(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('defaultAmountCents: $defaultAmountCents, ')
          ..write('dueDay: $dueDay, ')
          ..write('active: $active, ')
          ..write('creditCardId: $creditCardId, ')
          ..write('startMonth: $startMonth')
          ..write(')'))
        .toString();
  }
}

class $DebtsTable extends Debts with TableInfo<$DebtsTable, DebtRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DebtValueMode, String> valueMode =
      GeneratedColumn<String>(
        'value_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DebtValueMode>($DebtsTable.$convertervalueMode);
  static const VerificationMeta _totalCentsMeta = const VerificationMeta(
    'totalCents',
  );
  @override
  late final GeneratedColumn<int> totalCents = GeneratedColumn<int>(
    'total_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    description,
    valueMode,
    totalCents,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debts';
  @override
  VerificationContext validateIntegrity(
    Insertable<DebtRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('total_cents')) {
      context.handle(
        _totalCentsMeta,
        totalCents.isAcceptableOrUnknown(data['total_cents']!, _totalCentsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DebtRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DebtRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      valueMode: $DebtsTable.$convertervalueMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}value_mode'],
        )!,
      ),
      totalCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_cents'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DebtsTable createAlias(String alias) {
    return $DebtsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DebtValueMode, String, String> $convertervalueMode =
      const EnumNameConverter<DebtValueMode>(DebtValueMode.values);
}

class DebtRow extends DataClass implements Insertable<DebtRow> {
  final int id;
  final String description;
  final DebtValueMode valueMode;

  /// Total informado no modo [DebtValueMode.total].
  final int? totalCents;
  final DateTime createdAt;
  const DebtRow({
    required this.id,
    required this.description,
    required this.valueMode,
    this.totalCents,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['description'] = Variable<String>(description);
    {
      map['value_mode'] = Variable<String>(
        $DebtsTable.$convertervalueMode.toSql(valueMode),
      );
    }
    if (!nullToAbsent || totalCents != null) {
      map['total_cents'] = Variable<int>(totalCents);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DebtsCompanion toCompanion(bool nullToAbsent) {
    return DebtsCompanion(
      id: Value(id),
      description: Value(description),
      valueMode: Value(valueMode),
      totalCents: totalCents == null && nullToAbsent
          ? const Value.absent()
          : Value(totalCents),
      createdAt: Value(createdAt),
    );
  }

  factory DebtRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DebtRow(
      id: serializer.fromJson<int>(json['id']),
      description: serializer.fromJson<String>(json['description']),
      valueMode: $DebtsTable.$convertervalueMode.fromJson(
        serializer.fromJson<String>(json['valueMode']),
      ),
      totalCents: serializer.fromJson<int?>(json['totalCents']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'description': serializer.toJson<String>(description),
      'valueMode': serializer.toJson<String>(
        $DebtsTable.$convertervalueMode.toJson(valueMode),
      ),
      'totalCents': serializer.toJson<int?>(totalCents),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DebtRow copyWith({
    int? id,
    String? description,
    DebtValueMode? valueMode,
    Value<int?> totalCents = const Value.absent(),
    DateTime? createdAt,
  }) => DebtRow(
    id: id ?? this.id,
    description: description ?? this.description,
    valueMode: valueMode ?? this.valueMode,
    totalCents: totalCents.present ? totalCents.value : this.totalCents,
    createdAt: createdAt ?? this.createdAt,
  );
  DebtRow copyWithCompanion(DebtsCompanion data) {
    return DebtRow(
      id: data.id.present ? data.id.value : this.id,
      description: data.description.present
          ? data.description.value
          : this.description,
      valueMode: data.valueMode.present ? data.valueMode.value : this.valueMode,
      totalCents: data.totalCents.present
          ? data.totalCents.value
          : this.totalCents,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DebtRow(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('valueMode: $valueMode, ')
          ..write('totalCents: $totalCents, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, description, valueMode, totalCents, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DebtRow &&
          other.id == this.id &&
          other.description == this.description &&
          other.valueMode == this.valueMode &&
          other.totalCents == this.totalCents &&
          other.createdAt == this.createdAt);
}

class DebtsCompanion extends UpdateCompanion<DebtRow> {
  final Value<int> id;
  final Value<String> description;
  final Value<DebtValueMode> valueMode;
  final Value<int?> totalCents;
  final Value<DateTime> createdAt;
  const DebtsCompanion({
    this.id = const Value.absent(),
    this.description = const Value.absent(),
    this.valueMode = const Value.absent(),
    this.totalCents = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DebtsCompanion.insert({
    this.id = const Value.absent(),
    required String description,
    required DebtValueMode valueMode,
    this.totalCents = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : description = Value(description),
       valueMode = Value(valueMode);
  static Insertable<DebtRow> custom({
    Expression<int>? id,
    Expression<String>? description,
    Expression<String>? valueMode,
    Expression<int>? totalCents,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (description != null) 'description': description,
      if (valueMode != null) 'value_mode': valueMode,
      if (totalCents != null) 'total_cents': totalCents,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DebtsCompanion copyWith({
    Value<int>? id,
    Value<String>? description,
    Value<DebtValueMode>? valueMode,
    Value<int?>? totalCents,
    Value<DateTime>? createdAt,
  }) {
    return DebtsCompanion(
      id: id ?? this.id,
      description: description ?? this.description,
      valueMode: valueMode ?? this.valueMode,
      totalCents: totalCents ?? this.totalCents,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (valueMode.present) {
      map['value_mode'] = Variable<String>(
        $DebtsTable.$convertervalueMode.toSql(valueMode.value),
      );
    }
    if (totalCents.present) {
      map['total_cents'] = Variable<int>(totalCents.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtsCompanion(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('valueMode: $valueMode, ')
          ..write('totalCents: $totalCents, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DebtInstallmentsTable extends DebtInstallments
    with TableInfo<$DebtInstallmentsTable, DebtInstallmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtInstallmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _debtIdMeta = const VerificationMeta('debtId');
  @override
  late final GeneratedColumn<int> debtId = GeneratedColumn<int>(
    'debt_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES debts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
    'paid_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    debtId,
    number,
    dueDate,
    amountCents,
    paidAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debt_installments';
  @override
  VerificationContext validateIntegrity(
    Insertable<DebtInstallmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('debt_id')) {
      context.handle(
        _debtIdMeta,
        debtId.isAcceptableOrUnknown(data['debt_id']!, _debtIdMeta),
      );
    } else if (isInserting) {
      context.missing(_debtIdMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(
        _paidAtMeta,
        paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DebtInstallmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DebtInstallmentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      debtId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}debt_id'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      paidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_at'],
      ),
    );
  }

  @override
  $DebtInstallmentsTable createAlias(String alias) {
    return $DebtInstallmentsTable(attachedDatabase, alias);
  }
}

class DebtInstallmentRow extends DataClass
    implements Insertable<DebtInstallmentRow> {
  final int id;
  final int debtId;
  final int number;
  final DateTime dueDate;
  final int amountCents;
  final DateTime? paidAt;
  const DebtInstallmentRow({
    required this.id,
    required this.debtId,
    required this.number,
    required this.dueDate,
    required this.amountCents,
    this.paidAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['debt_id'] = Variable<int>(debtId);
    map['number'] = Variable<int>(number);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['amount_cents'] = Variable<int>(amountCents);
    if (!nullToAbsent || paidAt != null) {
      map['paid_at'] = Variable<DateTime>(paidAt);
    }
    return map;
  }

  DebtInstallmentsCompanion toCompanion(bool nullToAbsent) {
    return DebtInstallmentsCompanion(
      id: Value(id),
      debtId: Value(debtId),
      number: Value(number),
      dueDate: Value(dueDate),
      amountCents: Value(amountCents),
      paidAt: paidAt == null && nullToAbsent
          ? const Value.absent()
          : Value(paidAt),
    );
  }

  factory DebtInstallmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DebtInstallmentRow(
      id: serializer.fromJson<int>(json['id']),
      debtId: serializer.fromJson<int>(json['debtId']),
      number: serializer.fromJson<int>(json['number']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      paidAt: serializer.fromJson<DateTime?>(json['paidAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'debtId': serializer.toJson<int>(debtId),
      'number': serializer.toJson<int>(number),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'amountCents': serializer.toJson<int>(amountCents),
      'paidAt': serializer.toJson<DateTime?>(paidAt),
    };
  }

  DebtInstallmentRow copyWith({
    int? id,
    int? debtId,
    int? number,
    DateTime? dueDate,
    int? amountCents,
    Value<DateTime?> paidAt = const Value.absent(),
  }) => DebtInstallmentRow(
    id: id ?? this.id,
    debtId: debtId ?? this.debtId,
    number: number ?? this.number,
    dueDate: dueDate ?? this.dueDate,
    amountCents: amountCents ?? this.amountCents,
    paidAt: paidAt.present ? paidAt.value : this.paidAt,
  );
  DebtInstallmentRow copyWithCompanion(DebtInstallmentsCompanion data) {
    return DebtInstallmentRow(
      id: data.id.present ? data.id.value : this.id,
      debtId: data.debtId.present ? data.debtId.value : this.debtId,
      number: data.number.present ? data.number.value : this.number,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DebtInstallmentRow(')
          ..write('id: $id, ')
          ..write('debtId: $debtId, ')
          ..write('number: $number, ')
          ..write('dueDate: $dueDate, ')
          ..write('amountCents: $amountCents, ')
          ..write('paidAt: $paidAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, debtId, number, dueDate, amountCents, paidAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DebtInstallmentRow &&
          other.id == this.id &&
          other.debtId == this.debtId &&
          other.number == this.number &&
          other.dueDate == this.dueDate &&
          other.amountCents == this.amountCents &&
          other.paidAt == this.paidAt);
}

class DebtInstallmentsCompanion extends UpdateCompanion<DebtInstallmentRow> {
  final Value<int> id;
  final Value<int> debtId;
  final Value<int> number;
  final Value<DateTime> dueDate;
  final Value<int> amountCents;
  final Value<DateTime?> paidAt;
  const DebtInstallmentsCompanion({
    this.id = const Value.absent(),
    this.debtId = const Value.absent(),
    this.number = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.paidAt = const Value.absent(),
  });
  DebtInstallmentsCompanion.insert({
    this.id = const Value.absent(),
    required int debtId,
    required int number,
    required DateTime dueDate,
    required int amountCents,
    this.paidAt = const Value.absent(),
  }) : debtId = Value(debtId),
       number = Value(number),
       dueDate = Value(dueDate),
       amountCents = Value(amountCents);
  static Insertable<DebtInstallmentRow> custom({
    Expression<int>? id,
    Expression<int>? debtId,
    Expression<int>? number,
    Expression<DateTime>? dueDate,
    Expression<int>? amountCents,
    Expression<DateTime>? paidAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (debtId != null) 'debt_id': debtId,
      if (number != null) 'number': number,
      if (dueDate != null) 'due_date': dueDate,
      if (amountCents != null) 'amount_cents': amountCents,
      if (paidAt != null) 'paid_at': paidAt,
    });
  }

  DebtInstallmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? debtId,
    Value<int>? number,
    Value<DateTime>? dueDate,
    Value<int>? amountCents,
    Value<DateTime?>? paidAt,
  }) {
    return DebtInstallmentsCompanion(
      id: id ?? this.id,
      debtId: debtId ?? this.debtId,
      number: number ?? this.number,
      dueDate: dueDate ?? this.dueDate,
      amountCents: amountCents ?? this.amountCents,
      paidAt: paidAt ?? this.paidAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (debtId.present) {
      map['debt_id'] = Variable<int>(debtId.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtInstallmentsCompanion(')
          ..write('id: $id, ')
          ..write('debtId: $debtId, ')
          ..write('number: $number, ')
          ..write('dueDate: $dueDate, ')
          ..write('amountCents: $amountCents, ')
          ..write('paidAt: $paidAt')
          ..write(')'))
        .toString();
  }
}

class $CardPurchasesTable extends CardPurchases
    with TableInfo<$CardPurchasesTable, CardPurchaseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardPurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<int> cardId = GeneratedColumn<int>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES credit_cards (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCentsMeta = const VerificationMeta(
    'totalCents',
  );
  @override
  late final GeneratedColumn<int> totalCents = GeneratedColumn<int>(
    'total_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
    'purchase_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _installmentCountMeta = const VerificationMeta(
    'installmentCount',
  );
  @override
  late final GeneratedColumn<int> installmentCount = GeneratedColumn<int>(
    'installment_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    description,
    totalCents,
    purchaseDate,
    installmentCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_purchases';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardPurchaseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('total_cents')) {
      context.handle(
        _totalCentsMeta,
        totalCents.isAcceptableOrUnknown(data['total_cents']!, _totalCentsMeta),
      );
    } else if (isInserting) {
      context.missing(_totalCentsMeta);
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchaseDateMeta);
    }
    if (data.containsKey('installment_count')) {
      context.handle(
        _installmentCountMeta,
        installmentCount.isAcceptableOrUnknown(
          data['installment_count']!,
          _installmentCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installmentCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardPurchaseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardPurchaseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      totalCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_cents'],
      )!,
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchase_date'],
      )!,
      installmentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}installment_count'],
      )!,
    );
  }

  @override
  $CardPurchasesTable createAlias(String alias) {
    return $CardPurchasesTable(attachedDatabase, alias);
  }
}

class CardPurchaseRow extends DataClass implements Insertable<CardPurchaseRow> {
  final int id;
  final int cardId;
  final String description;
  final int totalCents;
  final DateTime purchaseDate;

  /// 1 = à vista.
  final int installmentCount;
  const CardPurchaseRow({
    required this.id,
    required this.cardId,
    required this.description,
    required this.totalCents,
    required this.purchaseDate,
    required this.installmentCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_id'] = Variable<int>(cardId);
    map['description'] = Variable<String>(description);
    map['total_cents'] = Variable<int>(totalCents);
    map['purchase_date'] = Variable<DateTime>(purchaseDate);
    map['installment_count'] = Variable<int>(installmentCount);
    return map;
  }

  CardPurchasesCompanion toCompanion(bool nullToAbsent) {
    return CardPurchasesCompanion(
      id: Value(id),
      cardId: Value(cardId),
      description: Value(description),
      totalCents: Value(totalCents),
      purchaseDate: Value(purchaseDate),
      installmentCount: Value(installmentCount),
    );
  }

  factory CardPurchaseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardPurchaseRow(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<int>(json['cardId']),
      description: serializer.fromJson<String>(json['description']),
      totalCents: serializer.fromJson<int>(json['totalCents']),
      purchaseDate: serializer.fromJson<DateTime>(json['purchaseDate']),
      installmentCount: serializer.fromJson<int>(json['installmentCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<int>(cardId),
      'description': serializer.toJson<String>(description),
      'totalCents': serializer.toJson<int>(totalCents),
      'purchaseDate': serializer.toJson<DateTime>(purchaseDate),
      'installmentCount': serializer.toJson<int>(installmentCount),
    };
  }

  CardPurchaseRow copyWith({
    int? id,
    int? cardId,
    String? description,
    int? totalCents,
    DateTime? purchaseDate,
    int? installmentCount,
  }) => CardPurchaseRow(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    description: description ?? this.description,
    totalCents: totalCents ?? this.totalCents,
    purchaseDate: purchaseDate ?? this.purchaseDate,
    installmentCount: installmentCount ?? this.installmentCount,
  );
  CardPurchaseRow copyWithCompanion(CardPurchasesCompanion data) {
    return CardPurchaseRow(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      description: data.description.present
          ? data.description.value
          : this.description,
      totalCents: data.totalCents.present
          ? data.totalCents.value
          : this.totalCents,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      installmentCount: data.installmentCount.present
          ? data.installmentCount.value
          : this.installmentCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardPurchaseRow(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('description: $description, ')
          ..write('totalCents: $totalCents, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('installmentCount: $installmentCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardId,
    description,
    totalCents,
    purchaseDate,
    installmentCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardPurchaseRow &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.description == this.description &&
          other.totalCents == this.totalCents &&
          other.purchaseDate == this.purchaseDate &&
          other.installmentCount == this.installmentCount);
}

class CardPurchasesCompanion extends UpdateCompanion<CardPurchaseRow> {
  final Value<int> id;
  final Value<int> cardId;
  final Value<String> description;
  final Value<int> totalCents;
  final Value<DateTime> purchaseDate;
  final Value<int> installmentCount;
  const CardPurchasesCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.description = const Value.absent(),
    this.totalCents = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.installmentCount = const Value.absent(),
  });
  CardPurchasesCompanion.insert({
    this.id = const Value.absent(),
    required int cardId,
    required String description,
    required int totalCents,
    required DateTime purchaseDate,
    required int installmentCount,
  }) : cardId = Value(cardId),
       description = Value(description),
       totalCents = Value(totalCents),
       purchaseDate = Value(purchaseDate),
       installmentCount = Value(installmentCount);
  static Insertable<CardPurchaseRow> custom({
    Expression<int>? id,
    Expression<int>? cardId,
    Expression<String>? description,
    Expression<int>? totalCents,
    Expression<DateTime>? purchaseDate,
    Expression<int>? installmentCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (description != null) 'description': description,
      if (totalCents != null) 'total_cents': totalCents,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (installmentCount != null) 'installment_count': installmentCount,
    });
  }

  CardPurchasesCompanion copyWith({
    Value<int>? id,
    Value<int>? cardId,
    Value<String>? description,
    Value<int>? totalCents,
    Value<DateTime>? purchaseDate,
    Value<int>? installmentCount,
  }) {
    return CardPurchasesCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      description: description ?? this.description,
      totalCents: totalCents ?? this.totalCents,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      installmentCount: installmentCount ?? this.installmentCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<int>(cardId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (totalCents.present) {
      map['total_cents'] = Variable<int>(totalCents.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (installmentCount.present) {
      map['installment_count'] = Variable<int>(installmentCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardPurchasesCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('description: $description, ')
          ..write('totalCents: $totalCents, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('installmentCount: $installmentCount')
          ..write(')'))
        .toString();
  }
}

class $CardPurchaseInstallmentsTable extends CardPurchaseInstallments
    with TableInfo<$CardPurchaseInstallmentsTable, CardPurchaseInstallmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardPurchaseInstallmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _purchaseIdMeta = const VerificationMeta(
    'purchaseId',
  );
  @override
  late final GeneratedColumn<int> purchaseId = GeneratedColumn<int>(
    'purchase_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES card_purchases (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _invoiceMonthMeta = const VerificationMeta(
    'invoiceMonth',
  );
  @override
  late final GeneratedColumn<int> invoiceMonth = GeneratedColumn<int>(
    'invoice_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    purchaseId,
    number,
    invoiceMonth,
    amountCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_purchase_installments';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardPurchaseInstallmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
        _purchaseIdMeta,
        purchaseId.isAcceptableOrUnknown(data['purchase_id']!, _purchaseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_purchaseIdMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('invoice_month')) {
      context.handle(
        _invoiceMonthMeta,
        invoiceMonth.isAcceptableOrUnknown(
          data['invoice_month']!,
          _invoiceMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invoiceMonthMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardPurchaseInstallmentRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardPurchaseInstallmentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      purchaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_id'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number'],
      )!,
      invoiceMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invoice_month'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
    );
  }

  @override
  $CardPurchaseInstallmentsTable createAlias(String alias) {
    return $CardPurchaseInstallmentsTable(attachedDatabase, alias);
  }
}

class CardPurchaseInstallmentRow extends DataClass
    implements Insertable<CardPurchaseInstallmentRow> {
  final int id;
  final int purchaseId;
  final int number;

  /// Mês de vencimento da fatura (`yyyymm`).
  final int invoiceMonth;
  final int amountCents;
  const CardPurchaseInstallmentRow({
    required this.id,
    required this.purchaseId,
    required this.number,
    required this.invoiceMonth,
    required this.amountCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['purchase_id'] = Variable<int>(purchaseId);
    map['number'] = Variable<int>(number);
    map['invoice_month'] = Variable<int>(invoiceMonth);
    map['amount_cents'] = Variable<int>(amountCents);
    return map;
  }

  CardPurchaseInstallmentsCompanion toCompanion(bool nullToAbsent) {
    return CardPurchaseInstallmentsCompanion(
      id: Value(id),
      purchaseId: Value(purchaseId),
      number: Value(number),
      invoiceMonth: Value(invoiceMonth),
      amountCents: Value(amountCents),
    );
  }

  factory CardPurchaseInstallmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardPurchaseInstallmentRow(
      id: serializer.fromJson<int>(json['id']),
      purchaseId: serializer.fromJson<int>(json['purchaseId']),
      number: serializer.fromJson<int>(json['number']),
      invoiceMonth: serializer.fromJson<int>(json['invoiceMonth']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'purchaseId': serializer.toJson<int>(purchaseId),
      'number': serializer.toJson<int>(number),
      'invoiceMonth': serializer.toJson<int>(invoiceMonth),
      'amountCents': serializer.toJson<int>(amountCents),
    };
  }

  CardPurchaseInstallmentRow copyWith({
    int? id,
    int? purchaseId,
    int? number,
    int? invoiceMonth,
    int? amountCents,
  }) => CardPurchaseInstallmentRow(
    id: id ?? this.id,
    purchaseId: purchaseId ?? this.purchaseId,
    number: number ?? this.number,
    invoiceMonth: invoiceMonth ?? this.invoiceMonth,
    amountCents: amountCents ?? this.amountCents,
  );
  CardPurchaseInstallmentRow copyWithCompanion(
    CardPurchaseInstallmentsCompanion data,
  ) {
    return CardPurchaseInstallmentRow(
      id: data.id.present ? data.id.value : this.id,
      purchaseId: data.purchaseId.present
          ? data.purchaseId.value
          : this.purchaseId,
      number: data.number.present ? data.number.value : this.number,
      invoiceMonth: data.invoiceMonth.present
          ? data.invoiceMonth.value
          : this.invoiceMonth,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardPurchaseInstallmentRow(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('number: $number, ')
          ..write('invoiceMonth: $invoiceMonth, ')
          ..write('amountCents: $amountCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, purchaseId, number, invoiceMonth, amountCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardPurchaseInstallmentRow &&
          other.id == this.id &&
          other.purchaseId == this.purchaseId &&
          other.number == this.number &&
          other.invoiceMonth == this.invoiceMonth &&
          other.amountCents == this.amountCents);
}

class CardPurchaseInstallmentsCompanion
    extends UpdateCompanion<CardPurchaseInstallmentRow> {
  final Value<int> id;
  final Value<int> purchaseId;
  final Value<int> number;
  final Value<int> invoiceMonth;
  final Value<int> amountCents;
  const CardPurchaseInstallmentsCompanion({
    this.id = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.number = const Value.absent(),
    this.invoiceMonth = const Value.absent(),
    this.amountCents = const Value.absent(),
  });
  CardPurchaseInstallmentsCompanion.insert({
    this.id = const Value.absent(),
    required int purchaseId,
    required int number,
    required int invoiceMonth,
    required int amountCents,
  }) : purchaseId = Value(purchaseId),
       number = Value(number),
       invoiceMonth = Value(invoiceMonth),
       amountCents = Value(amountCents);
  static Insertable<CardPurchaseInstallmentRow> custom({
    Expression<int>? id,
    Expression<int>? purchaseId,
    Expression<int>? number,
    Expression<int>? invoiceMonth,
    Expression<int>? amountCents,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (number != null) 'number': number,
      if (invoiceMonth != null) 'invoice_month': invoiceMonth,
      if (amountCents != null) 'amount_cents': amountCents,
    });
  }

  CardPurchaseInstallmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? purchaseId,
    Value<int>? number,
    Value<int>? invoiceMonth,
    Value<int>? amountCents,
  }) {
    return CardPurchaseInstallmentsCompanion(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      number: number ?? this.number,
      invoiceMonth: invoiceMonth ?? this.invoiceMonth,
      amountCents: amountCents ?? this.amountCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<int>(purchaseId.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (invoiceMonth.present) {
      map['invoice_month'] = Variable<int>(invoiceMonth.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardPurchaseInstallmentsCompanion(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('number: $number, ')
          ..write('invoiceMonth: $invoiceMonth, ')
          ..write('amountCents: $amountCents')
          ..write(')'))
        .toString();
  }
}

class $OneOffEntriesTable extends OneOffEntries
    with TableInfo<$OneOffEntriesTable, OneOffEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OneOffEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<EntryKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EntryKind>($OneOffEntriesTable.$converterkind);
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
    'paid_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    description,
    amountCents,
    date,
    paidAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'one_off_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<OneOffEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(
        _paidAtMeta,
        paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OneOffEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OneOffEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: $OneOffEntriesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      paidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_at'],
      ),
    );
  }

  @override
  $OneOffEntriesTable createAlias(String alias) {
    return $OneOffEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EntryKind, String, String> $converterkind =
      const EnumNameConverter<EntryKind>(EntryKind.values);
}

class OneOffEntryRow extends DataClass implements Insertable<OneOffEntryRow> {
  final int id;
  final EntryKind kind;
  final String description;
  final int amountCents;
  final DateTime date;
  final DateTime? paidAt;
  const OneOffEntryRow({
    required this.id,
    required this.kind,
    required this.description,
    required this.amountCents,
    required this.date,
    this.paidAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['kind'] = Variable<String>(
        $OneOffEntriesTable.$converterkind.toSql(kind),
      );
    }
    map['description'] = Variable<String>(description);
    map['amount_cents'] = Variable<int>(amountCents);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || paidAt != null) {
      map['paid_at'] = Variable<DateTime>(paidAt);
    }
    return map;
  }

  OneOffEntriesCompanion toCompanion(bool nullToAbsent) {
    return OneOffEntriesCompanion(
      id: Value(id),
      kind: Value(kind),
      description: Value(description),
      amountCents: Value(amountCents),
      date: Value(date),
      paidAt: paidAt == null && nullToAbsent
          ? const Value.absent()
          : Value(paidAt),
    );
  }

  factory OneOffEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OneOffEntryRow(
      id: serializer.fromJson<int>(json['id']),
      kind: $OneOffEntriesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      description: serializer.fromJson<String>(json['description']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      date: serializer.fromJson<DateTime>(json['date']),
      paidAt: serializer.fromJson<DateTime?>(json['paidAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(
        $OneOffEntriesTable.$converterkind.toJson(kind),
      ),
      'description': serializer.toJson<String>(description),
      'amountCents': serializer.toJson<int>(amountCents),
      'date': serializer.toJson<DateTime>(date),
      'paidAt': serializer.toJson<DateTime?>(paidAt),
    };
  }

  OneOffEntryRow copyWith({
    int? id,
    EntryKind? kind,
    String? description,
    int? amountCents,
    DateTime? date,
    Value<DateTime?> paidAt = const Value.absent(),
  }) => OneOffEntryRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    description: description ?? this.description,
    amountCents: amountCents ?? this.amountCents,
    date: date ?? this.date,
    paidAt: paidAt.present ? paidAt.value : this.paidAt,
  );
  OneOffEntryRow copyWithCompanion(OneOffEntriesCompanion data) {
    return OneOffEntryRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      description: data.description.present
          ? data.description.value
          : this.description,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      date: data.date.present ? data.date.value : this.date,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OneOffEntryRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('description: $description, ')
          ..write('amountCents: $amountCents, ')
          ..write('date: $date, ')
          ..write('paidAt: $paidAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, kind, description, amountCents, date, paidAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OneOffEntryRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.description == this.description &&
          other.amountCents == this.amountCents &&
          other.date == this.date &&
          other.paidAt == this.paidAt);
}

class OneOffEntriesCompanion extends UpdateCompanion<OneOffEntryRow> {
  final Value<int> id;
  final Value<EntryKind> kind;
  final Value<String> description;
  final Value<int> amountCents;
  final Value<DateTime> date;
  final Value<DateTime?> paidAt;
  const OneOffEntriesCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.description = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.date = const Value.absent(),
    this.paidAt = const Value.absent(),
  });
  OneOffEntriesCompanion.insert({
    this.id = const Value.absent(),
    required EntryKind kind,
    required String description,
    required int amountCents,
    required DateTime date,
    this.paidAt = const Value.absent(),
  }) : kind = Value(kind),
       description = Value(description),
       amountCents = Value(amountCents),
       date = Value(date);
  static Insertable<OneOffEntryRow> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<String>? description,
    Expression<int>? amountCents,
    Expression<DateTime>? date,
    Expression<DateTime>? paidAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (description != null) 'description': description,
      if (amountCents != null) 'amount_cents': amountCents,
      if (date != null) 'date': date,
      if (paidAt != null) 'paid_at': paidAt,
    });
  }

  OneOffEntriesCompanion copyWith({
    Value<int>? id,
    Value<EntryKind>? kind,
    Value<String>? description,
    Value<int>? amountCents,
    Value<DateTime>? date,
    Value<DateTime?>? paidAt,
  }) {
    return OneOffEntriesCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      description: description ?? this.description,
      amountCents: amountCents ?? this.amountCents,
      date: date ?? this.date,
      paidAt: paidAt ?? this.paidAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $OneOffEntriesTable.$converterkind.toSql(kind.value),
      );
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OneOffEntriesCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('description: $description, ')
          ..write('amountCents: $amountCents, ')
          ..write('date: $date, ')
          ..write('paidAt: $paidAt')
          ..write(')'))
        .toString();
  }
}

class $MonthlyRecordsTable extends MonthlyRecords
    with TableInfo<$MonthlyRecordsTable, MonthlyRecordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonthlyRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<RecordSource, String> sourceType =
      GeneratedColumn<String>(
        'source_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RecordSource>($MonthlyRecordsTable.$convertersourceType);
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<int> sourceId = GeneratedColumn<int>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountOverrideCentsMeta =
      const VerificationMeta('amountOverrideCents');
  @override
  late final GeneratedColumn<int> amountOverrideCents = GeneratedColumn<int>(
    'amount_override_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
    'paid_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceType,
    sourceId,
    month,
    amountOverrideCents,
    paidAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monthly_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<MonthlyRecordRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('amount_override_cents')) {
      context.handle(
        _amountOverrideCentsMeta,
        amountOverrideCents.isAcceptableOrUnknown(
          data['amount_override_cents']!,
          _amountOverrideCentsMeta,
        ),
      );
    }
    if (data.containsKey('paid_at')) {
      context.handle(
        _paidAtMeta,
        paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {sourceType, sourceId, month},
  ];
  @override
  MonthlyRecordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonthlyRecordRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sourceType: $MonthlyRecordsTable.$convertersourceType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source_type'],
        )!,
      ),
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_id'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      amountOverrideCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_override_cents'],
      ),
      paidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_at'],
      ),
    );
  }

  @override
  $MonthlyRecordsTable createAlias(String alias) {
    return $MonthlyRecordsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RecordSource, String, String> $convertersourceType =
      const EnumNameConverter<RecordSource>(RecordSource.values);
}

class MonthlyRecordRow extends DataClass
    implements Insertable<MonthlyRecordRow> {
  final int id;
  final RecordSource sourceType;

  /// Id da receita, despesa fixa ou cartão, conforme [sourceType].
  final int sourceId;
  final int month;

  /// Valor real do mês. Para faturas, é o "valor total da fatura".
  final int? amountOverrideCents;
  final DateTime? paidAt;
  const MonthlyRecordRow({
    required this.id,
    required this.sourceType,
    required this.sourceId,
    required this.month,
    this.amountOverrideCents,
    this.paidAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['source_type'] = Variable<String>(
        $MonthlyRecordsTable.$convertersourceType.toSql(sourceType),
      );
    }
    map['source_id'] = Variable<int>(sourceId);
    map['month'] = Variable<int>(month);
    if (!nullToAbsent || amountOverrideCents != null) {
      map['amount_override_cents'] = Variable<int>(amountOverrideCents);
    }
    if (!nullToAbsent || paidAt != null) {
      map['paid_at'] = Variable<DateTime>(paidAt);
    }
    return map;
  }

  MonthlyRecordsCompanion toCompanion(bool nullToAbsent) {
    return MonthlyRecordsCompanion(
      id: Value(id),
      sourceType: Value(sourceType),
      sourceId: Value(sourceId),
      month: Value(month),
      amountOverrideCents: amountOverrideCents == null && nullToAbsent
          ? const Value.absent()
          : Value(amountOverrideCents),
      paidAt: paidAt == null && nullToAbsent
          ? const Value.absent()
          : Value(paidAt),
    );
  }

  factory MonthlyRecordRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonthlyRecordRow(
      id: serializer.fromJson<int>(json['id']),
      sourceType: $MonthlyRecordsTable.$convertersourceType.fromJson(
        serializer.fromJson<String>(json['sourceType']),
      ),
      sourceId: serializer.fromJson<int>(json['sourceId']),
      month: serializer.fromJson<int>(json['month']),
      amountOverrideCents: serializer.fromJson<int?>(
        json['amountOverrideCents'],
      ),
      paidAt: serializer.fromJson<DateTime?>(json['paidAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sourceType': serializer.toJson<String>(
        $MonthlyRecordsTable.$convertersourceType.toJson(sourceType),
      ),
      'sourceId': serializer.toJson<int>(sourceId),
      'month': serializer.toJson<int>(month),
      'amountOverrideCents': serializer.toJson<int?>(amountOverrideCents),
      'paidAt': serializer.toJson<DateTime?>(paidAt),
    };
  }

  MonthlyRecordRow copyWith({
    int? id,
    RecordSource? sourceType,
    int? sourceId,
    int? month,
    Value<int?> amountOverrideCents = const Value.absent(),
    Value<DateTime?> paidAt = const Value.absent(),
  }) => MonthlyRecordRow(
    id: id ?? this.id,
    sourceType: sourceType ?? this.sourceType,
    sourceId: sourceId ?? this.sourceId,
    month: month ?? this.month,
    amountOverrideCents: amountOverrideCents.present
        ? amountOverrideCents.value
        : this.amountOverrideCents,
    paidAt: paidAt.present ? paidAt.value : this.paidAt,
  );
  MonthlyRecordRow copyWithCompanion(MonthlyRecordsCompanion data) {
    return MonthlyRecordRow(
      id: data.id.present ? data.id.value : this.id,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      month: data.month.present ? data.month.value : this.month,
      amountOverrideCents: data.amountOverrideCents.present
          ? data.amountOverrideCents.value
          : this.amountOverrideCents,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyRecordRow(')
          ..write('id: $id, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('month: $month, ')
          ..write('amountOverrideCents: $amountOverrideCents, ')
          ..write('paidAt: $paidAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sourceType, sourceId, month, amountOverrideCents, paidAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonthlyRecordRow &&
          other.id == this.id &&
          other.sourceType == this.sourceType &&
          other.sourceId == this.sourceId &&
          other.month == this.month &&
          other.amountOverrideCents == this.amountOverrideCents &&
          other.paidAt == this.paidAt);
}

class MonthlyRecordsCompanion extends UpdateCompanion<MonthlyRecordRow> {
  final Value<int> id;
  final Value<RecordSource> sourceType;
  final Value<int> sourceId;
  final Value<int> month;
  final Value<int?> amountOverrideCents;
  final Value<DateTime?> paidAt;
  const MonthlyRecordsCompanion({
    this.id = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.month = const Value.absent(),
    this.amountOverrideCents = const Value.absent(),
    this.paidAt = const Value.absent(),
  });
  MonthlyRecordsCompanion.insert({
    this.id = const Value.absent(),
    required RecordSource sourceType,
    required int sourceId,
    required int month,
    this.amountOverrideCents = const Value.absent(),
    this.paidAt = const Value.absent(),
  }) : sourceType = Value(sourceType),
       sourceId = Value(sourceId),
       month = Value(month);
  static Insertable<MonthlyRecordRow> custom({
    Expression<int>? id,
    Expression<String>? sourceType,
    Expression<int>? sourceId,
    Expression<int>? month,
    Expression<int>? amountOverrideCents,
    Expression<DateTime>? paidAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceId != null) 'source_id': sourceId,
      if (month != null) 'month': month,
      if (amountOverrideCents != null)
        'amount_override_cents': amountOverrideCents,
      if (paidAt != null) 'paid_at': paidAt,
    });
  }

  MonthlyRecordsCompanion copyWith({
    Value<int>? id,
    Value<RecordSource>? sourceType,
    Value<int>? sourceId,
    Value<int>? month,
    Value<int?>? amountOverrideCents,
    Value<DateTime?>? paidAt,
  }) {
    return MonthlyRecordsCompanion(
      id: id ?? this.id,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      month: month ?? this.month,
      amountOverrideCents: amountOverrideCents ?? this.amountOverrideCents,
      paidAt: paidAt ?? this.paidAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(
        $MonthlyRecordsTable.$convertersourceType.toSql(sourceType.value),
      );
    }
    if (sourceId.present) {
      map['source_id'] = Variable<int>(sourceId.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (amountOverrideCents.present) {
      map['amount_override_cents'] = Variable<int>(amountOverrideCents.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyRecordsCompanion(')
          ..write('id: $id, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('month: $month, ')
          ..write('amountOverrideCents: $amountOverrideCents, ')
          ..write('paidAt: $paidAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CreditCardsTable creditCards = $CreditCardsTable(this);
  late final $IncomesTable incomes = $IncomesTable(this);
  late final $FixedExpensesTable fixedExpenses = $FixedExpensesTable(this);
  late final $DebtsTable debts = $DebtsTable(this);
  late final $DebtInstallmentsTable debtInstallments = $DebtInstallmentsTable(
    this,
  );
  late final $CardPurchasesTable cardPurchases = $CardPurchasesTable(this);
  late final $CardPurchaseInstallmentsTable cardPurchaseInstallments =
      $CardPurchaseInstallmentsTable(this);
  late final $OneOffEntriesTable oneOffEntries = $OneOffEntriesTable(this);
  late final $MonthlyRecordsTable monthlyRecords = $MonthlyRecordsTable(this);
  late final Index idxDebtInstallmentsDueDate = Index(
    'idx_debt_installments_due_date',
    'CREATE INDEX idx_debt_installments_due_date ON debt_installments (due_date)',
  );
  late final Index idxCardPurchaseInstallmentsInvoiceMonth = Index(
    'idx_card_purchase_installments_invoice_month',
    'CREATE INDEX idx_card_purchase_installments_invoice_month ON card_purchase_installments (invoice_month)',
  );
  late final Index idxOneOffEntriesDate = Index(
    'idx_one_off_entries_date',
    'CREATE INDEX idx_one_off_entries_date ON one_off_entries (date)',
  );
  late final Index idxMonthlyRecordsMonth = Index(
    'idx_monthly_records_month',
    'CREATE INDEX idx_monthly_records_month ON monthly_records (month)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    creditCards,
    incomes,
    fixedExpenses,
    debts,
    debtInstallments,
    cardPurchases,
    cardPurchaseInstallments,
    oneOffEntries,
    monthlyRecords,
    idxDebtInstallmentsDueDate,
    idxCardPurchaseInstallmentsInvoiceMonth,
    idxOneOffEntriesDate,
    idxMonthlyRecordsMonth,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'credit_cards',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('fixed_expenses', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'debts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('debt_installments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'credit_cards',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('card_purchases', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'card_purchases',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('card_purchase_installments', kind: UpdateKind.delete),
      ],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$CreditCardsTableCreateCompanionBuilder =
    CreditCardsCompanion Function({
      Value<int> id,
      required String name,
      required int closingDay,
      required int dueDay,
      Value<int?> limitCents,
      Value<DateTime> createdAt,
    });
typedef $$CreditCardsTableUpdateCompanionBuilder =
    CreditCardsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> closingDay,
      Value<int> dueDay,
      Value<int?> limitCents,
      Value<DateTime> createdAt,
    });

final class $$CreditCardsTableReferences
    extends BaseReferences<_$AppDatabase, $CreditCardsTable, CreditCardRow> {
  $$CreditCardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FixedExpensesTable, List<FixedExpenseRow>>
  _fixedExpensesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.fixedExpenses,
    aliasName: 'credit_cards__id__fixed_expenses__credit_card_id',
  );

  $$FixedExpensesTableProcessedTableManager get fixedExpensesRefs {
    final manager = $$FixedExpensesTableTableManager(
      $_db,
      $_db.fixedExpenses,
    ).filter((f) => f.creditCardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_fixedExpensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CardPurchasesTable, List<CardPurchaseRow>>
  _cardPurchasesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cardPurchases,
    aliasName: 'credit_cards__id__card_purchases__card_id',
  );

  $$CardPurchasesTableProcessedTableManager get cardPurchasesRefs {
    final manager = $$CardPurchasesTableTableManager(
      $_db,
      $_db.cardPurchases,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cardPurchasesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CreditCardsTableFilterComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get closingDay => $composableBuilder(
    column: $table.closingDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get limitCents => $composableBuilder(
    column: $table.limitCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> fixedExpensesRefs(
    Expression<bool> Function($$FixedExpensesTableFilterComposer f) f,
  ) {
    final $$FixedExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fixedExpenses,
      getReferencedColumn: (t) => t.creditCardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FixedExpensesTableFilterComposer(
            $db: $db,
            $table: $db.fixedExpenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cardPurchasesRefs(
    Expression<bool> Function($$CardPurchasesTableFilterComposer f) f,
  ) {
    final $$CardPurchasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardPurchases,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardPurchasesTableFilterComposer(
            $db: $db,
            $table: $db.cardPurchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CreditCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get closingDay => $composableBuilder(
    column: $table.closingDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get limitCents => $composableBuilder(
    column: $table.limitCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CreditCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get closingDay => $composableBuilder(
    column: $table.closingDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dueDay =>
      $composableBuilder(column: $table.dueDay, builder: (column) => column);

  GeneratedColumn<int> get limitCents => $composableBuilder(
    column: $table.limitCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> fixedExpensesRefs<T extends Object>(
    Expression<T> Function($$FixedExpensesTableAnnotationComposer a) f,
  ) {
    final $$FixedExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fixedExpenses,
      getReferencedColumn: (t) => t.creditCardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FixedExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.fixedExpenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cardPurchasesRefs<T extends Object>(
    Expression<T> Function($$CardPurchasesTableAnnotationComposer a) f,
  ) {
    final $$CardPurchasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardPurchases,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardPurchasesTableAnnotationComposer(
            $db: $db,
            $table: $db.cardPurchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CreditCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreditCardsTable,
          CreditCardRow,
          $$CreditCardsTableFilterComposer,
          $$CreditCardsTableOrderingComposer,
          $$CreditCardsTableAnnotationComposer,
          $$CreditCardsTableCreateCompanionBuilder,
          $$CreditCardsTableUpdateCompanionBuilder,
          (CreditCardRow, $$CreditCardsTableReferences),
          CreditCardRow,
          PrefetchHooks Function({
            bool fixedExpensesRefs,
            bool cardPurchasesRefs,
          })
        > {
  $$CreditCardsTableTableManager(_$AppDatabase db, $CreditCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreditCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreditCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreditCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> closingDay = const Value.absent(),
                Value<int> dueDay = const Value.absent(),
                Value<int?> limitCents = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CreditCardsCompanion(
                id: id,
                name: name,
                closingDay: closingDay,
                dueDay: dueDay,
                limitCents: limitCents,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int closingDay,
                required int dueDay,
                Value<int?> limitCents = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CreditCardsCompanion.insert(
                id: id,
                name: name,
                closingDay: closingDay,
                dueDay: dueDay,
                limitCents: limitCents,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CreditCardsTable, CreditCardRow>(table),
                  $$CreditCardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({fixedExpensesRefs = false, cardPurchasesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (fixedExpensesRefs) db.fixedExpenses,
                    if (cardPurchasesRefs) db.cardPurchases,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (fixedExpensesRefs)
                        await $_getPrefetchedData<
                          CreditCardRow,
                          $CreditCardsTable,
                          FixedExpenseRow
                        >(
                          currentTable: table,
                          referencedTable: $$CreditCardsTableReferences
                              ._fixedExpensesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CreditCardsTableReferences(
                                db,
                                table,
                                p0,
                              ).fixedExpensesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.creditCardId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cardPurchasesRefs)
                        await $_getPrefetchedData<
                          CreditCardRow,
                          $CreditCardsTable,
                          CardPurchaseRow
                        >(
                          currentTable: table,
                          referencedTable: $$CreditCardsTableReferences
                              ._cardPurchasesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CreditCardsTableReferences(
                                db,
                                table,
                                p0,
                              ).cardPurchasesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cardId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CreditCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreditCardsTable,
      CreditCardRow,
      $$CreditCardsTableFilterComposer,
      $$CreditCardsTableOrderingComposer,
      $$CreditCardsTableAnnotationComposer,
      $$CreditCardsTableCreateCompanionBuilder,
      $$CreditCardsTableUpdateCompanionBuilder,
      (CreditCardRow, $$CreditCardsTableReferences),
      CreditCardRow,
      PrefetchHooks Function({bool fixedExpensesRefs, bool cardPurchasesRefs})
    >;
typedef $$IncomesTableCreateCompanionBuilder = IncomesCompanion Function({
  Value<int> id,
  required String description,
  required int amountCents,
  required int dayOfMonth,
  Value<bool> active,
  required int startMonth,
});
typedef $$IncomesTableUpdateCompanionBuilder = IncomesCompanion Function({
  Value<int> id,
  Value<String> description,
  Value<int> amountCents,
  Value<int> dayOfMonth,
  Value<bool> active,
  Value<int> startMonth,
});

class $$IncomesTableFilterComposer
    extends Composer<_$AppDatabase, $IncomesTable> {
  $$IncomesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMonth => $composableBuilder(
    column: $table.startMonth,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IncomesTableOrderingComposer
    extends Composer<_$AppDatabase, $IncomesTable> {
  $$IncomesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMonth => $composableBuilder(
    column: $table.startMonth,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IncomesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IncomesTable> {
  $$IncomesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<int> get startMonth => $composableBuilder(
    column: $table.startMonth,
    builder: (column) => column,
  );
}

class $$IncomesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IncomesTable,
          IncomeRow,
          $$IncomesTableFilterComposer,
          $$IncomesTableOrderingComposer,
          $$IncomesTableAnnotationComposer,
          $$IncomesTableCreateCompanionBuilder,
          $$IncomesTableUpdateCompanionBuilder,
          (IncomeRow, BaseReferences<_$AppDatabase, $IncomesTable, IncomeRow>),
          IncomeRow,
          PrefetchHooks Function()
        > {
  $$IncomesTableTableManager(_$AppDatabase db, $IncomesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncomesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncomesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IncomesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<int> dayOfMonth = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> startMonth = const Value.absent(),
              }) => IncomesCompanion(
                id: id,
                description: description,
                amountCents: amountCents,
                dayOfMonth: dayOfMonth,
                active: active,
                startMonth: startMonth,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String description,
                required int amountCents,
                required int dayOfMonth,
                Value<bool> active = const Value.absent(),
                required int startMonth,
              }) => IncomesCompanion.insert(
                id: id,
                description: description,
                amountCents: amountCents,
                dayOfMonth: dayOfMonth,
                active: active,
                startMonth: startMonth,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IncomesTable, IncomeRow>(table),
                  BaseReferences<_$AppDatabase, $IncomesTable, IncomeRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IncomesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IncomesTable,
      IncomeRow,
      $$IncomesTableFilterComposer,
      $$IncomesTableOrderingComposer,
      $$IncomesTableAnnotationComposer,
      $$IncomesTableCreateCompanionBuilder,
      $$IncomesTableUpdateCompanionBuilder,
      (IncomeRow, BaseReferences<_$AppDatabase, $IncomesTable, IncomeRow>),
      IncomeRow,
      PrefetchHooks Function()
    >;
typedef $$FixedExpensesTableCreateCompanionBuilder =
    FixedExpensesCompanion Function({
      Value<int> id,
      required String description,
      required int defaultAmountCents,
      required int dueDay,
      Value<bool> active,
      Value<int?> creditCardId,
      required int startMonth,
    });
typedef $$FixedExpensesTableUpdateCompanionBuilder =
    FixedExpensesCompanion Function({
      Value<int> id,
      Value<String> description,
      Value<int> defaultAmountCents,
      Value<int> dueDay,
      Value<bool> active,
      Value<int?> creditCardId,
      Value<int> startMonth,
    });

final class $$FixedExpensesTableReferences
    extends
        BaseReferences<_$AppDatabase, $FixedExpensesTable, FixedExpenseRow> {
  $$FixedExpensesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CreditCardsTable _creditCardIdTable(_$AppDatabase db) => db
      .creditCards
      .createAlias('fixed_expenses__credit_card_id__credit_cards__id');

  $$CreditCardsTableProcessedTableManager? get creditCardId {
    final $_column = $_itemColumn<int>('credit_card_id');
    if ($_column == null) return null;
    final manager = $$CreditCardsTableTableManager(
      $_db,
      $_db.creditCards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_creditCardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FixedExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $FixedExpensesTable> {
  $$FixedExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultAmountCents => $composableBuilder(
    column: $table.defaultAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMonth => $composableBuilder(
    column: $table.startMonth,
    builder: (column) => ColumnFilters(column),
  );

  $$CreditCardsTableFilterComposer get creditCardId {
    final $$CreditCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creditCardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableFilterComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FixedExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $FixedExpensesTable> {
  $$FixedExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultAmountCents => $composableBuilder(
    column: $table.defaultAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMonth => $composableBuilder(
    column: $table.startMonth,
    builder: (column) => ColumnOrderings(column),
  );

  $$CreditCardsTableOrderingComposer get creditCardId {
    final $$CreditCardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creditCardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableOrderingComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FixedExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FixedExpensesTable> {
  $$FixedExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultAmountCents => $composableBuilder(
    column: $table.defaultAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dueDay =>
      $composableBuilder(column: $table.dueDay, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<int> get startMonth => $composableBuilder(
    column: $table.startMonth,
    builder: (column) => column,
  );

  $$CreditCardsTableAnnotationComposer get creditCardId {
    final $$CreditCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creditCardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FixedExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FixedExpensesTable,
          FixedExpenseRow,
          $$FixedExpensesTableFilterComposer,
          $$FixedExpensesTableOrderingComposer,
          $$FixedExpensesTableAnnotationComposer,
          $$FixedExpensesTableCreateCompanionBuilder,
          $$FixedExpensesTableUpdateCompanionBuilder,
          (FixedExpenseRow, $$FixedExpensesTableReferences),
          FixedExpenseRow,
          PrefetchHooks Function({bool creditCardId})
        > {
  $$FixedExpensesTableTableManager(_$AppDatabase db, $FixedExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FixedExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FixedExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FixedExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> defaultAmountCents = const Value.absent(),
                Value<int> dueDay = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int?> creditCardId = const Value.absent(),
                Value<int> startMonth = const Value.absent(),
              }) => FixedExpensesCompanion(
                id: id,
                description: description,
                defaultAmountCents: defaultAmountCents,
                dueDay: dueDay,
                active: active,
                creditCardId: creditCardId,
                startMonth: startMonth,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String description,
                required int defaultAmountCents,
                required int dueDay,
                Value<bool> active = const Value.absent(),
                Value<int?> creditCardId = const Value.absent(),
                required int startMonth,
              }) => FixedExpensesCompanion.insert(
                id: id,
                description: description,
                defaultAmountCents: defaultAmountCents,
                dueDay: dueDay,
                active: active,
                creditCardId: creditCardId,
                startMonth: startMonth,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FixedExpensesTable, FixedExpenseRow>(table),
                  $$FixedExpensesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({creditCardId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (creditCardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.creditCardId,
                        referencedTable: $$FixedExpensesTableReferences
                            ._creditCardIdTable(db),
                        referencedColumn: $$FixedExpensesTableReferences
                            ._creditCardIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FixedExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FixedExpensesTable,
      FixedExpenseRow,
      $$FixedExpensesTableFilterComposer,
      $$FixedExpensesTableOrderingComposer,
      $$FixedExpensesTableAnnotationComposer,
      $$FixedExpensesTableCreateCompanionBuilder,
      $$FixedExpensesTableUpdateCompanionBuilder,
      (FixedExpenseRow, $$FixedExpensesTableReferences),
      FixedExpenseRow,
      PrefetchHooks Function({bool creditCardId})
    >;
typedef $$DebtsTableCreateCompanionBuilder = DebtsCompanion Function({
  Value<int> id,
  required String description,
  required DebtValueMode valueMode,
  Value<int?> totalCents,
  Value<DateTime> createdAt,
});
typedef $$DebtsTableUpdateCompanionBuilder = DebtsCompanion Function({
  Value<int> id,
  Value<String> description,
  Value<DebtValueMode> valueMode,
  Value<int?> totalCents,
  Value<DateTime> createdAt,
});

final class $$DebtsTableReferences
    extends BaseReferences<_$AppDatabase, $DebtsTable, DebtRow> {
  $$DebtsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DebtInstallmentsTable, List<DebtInstallmentRow>>
  _debtInstallmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.debtInstallments,
    aliasName: 'debts__id__debt_installments__debt_id',
  );

  $$DebtInstallmentsTableProcessedTableManager get debtInstallmentsRefs {
    final manager = $$DebtInstallmentsTableTableManager(
      $_db,
      $_db.debtInstallments,
    ).filter((f) => f.debtId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _debtInstallmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DebtsTableFilterComposer extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DebtValueMode, DebtValueMode, String>
  get valueMode => $composableBuilder(
    column: $table.valueMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get totalCents => $composableBuilder(
    column: $table.totalCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> debtInstallmentsRefs(
    Expression<bool> Function($$DebtInstallmentsTableFilterComposer f) f,
  ) {
    final $$DebtInstallmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.debtInstallments,
      getReferencedColumn: (t) => t.debtId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DebtInstallmentsTableFilterComposer(
            $db: $db,
            $table: $db.debtInstallments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DebtsTableOrderingComposer
    extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueMode => $composableBuilder(
    column: $table.valueMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCents => $composableBuilder(
    column: $table.totalCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DebtsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DebtValueMode, String> get valueMode =>
      $composableBuilder(column: $table.valueMode, builder: (column) => column);

  GeneratedColumn<int> get totalCents => $composableBuilder(
    column: $table.totalCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> debtInstallmentsRefs<T extends Object>(
    Expression<T> Function($$DebtInstallmentsTableAnnotationComposer a) f,
  ) {
    final $$DebtInstallmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.debtInstallments,
      getReferencedColumn: (t) => t.debtId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DebtInstallmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.debtInstallments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DebtsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DebtsTable,
          DebtRow,
          $$DebtsTableFilterComposer,
          $$DebtsTableOrderingComposer,
          $$DebtsTableAnnotationComposer,
          $$DebtsTableCreateCompanionBuilder,
          $$DebtsTableUpdateCompanionBuilder,
          (DebtRow, $$DebtsTableReferences),
          DebtRow,
          PrefetchHooks Function({bool debtInstallmentsRefs})
        > {
  $$DebtsTableTableManager(_$AppDatabase db, $DebtsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebtsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebtsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebtsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DebtValueMode> valueMode = const Value.absent(),
                Value<int?> totalCents = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DebtsCompanion(
                id: id,
                description: description,
                valueMode: valueMode,
                totalCents: totalCents,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String description,
                required DebtValueMode valueMode,
                Value<int?> totalCents = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DebtsCompanion.insert(
                id: id,
                description: description,
                valueMode: valueMode,
                totalCents: totalCents,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DebtsTable, DebtRow>(table),
                  $$DebtsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({debtInstallmentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (debtInstallmentsRefs) db.debtInstallments,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (debtInstallmentsRefs)
                    await $_getPrefetchedData<
                      DebtRow,
                      $DebtsTable,
                      DebtInstallmentRow
                    >(
                      currentTable: table,
                      referencedTable: $$DebtsTableReferences
                          ._debtInstallmentsRefsTable(db),
                      managerFromTypedResult: (p0) => $$DebtsTableReferences(
                        db,
                        table,
                        p0,
                      ).debtInstallmentsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.debtId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DebtsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DebtsTable,
      DebtRow,
      $$DebtsTableFilterComposer,
      $$DebtsTableOrderingComposer,
      $$DebtsTableAnnotationComposer,
      $$DebtsTableCreateCompanionBuilder,
      $$DebtsTableUpdateCompanionBuilder,
      (DebtRow, $$DebtsTableReferences),
      DebtRow,
      PrefetchHooks Function({bool debtInstallmentsRefs})
    >;
typedef $$DebtInstallmentsTableCreateCompanionBuilder =
    DebtInstallmentsCompanion Function({
      Value<int> id,
      required int debtId,
      required int number,
      required DateTime dueDate,
      required int amountCents,
      Value<DateTime?> paidAt,
    });
typedef $$DebtInstallmentsTableUpdateCompanionBuilder =
    DebtInstallmentsCompanion Function({
      Value<int> id,
      Value<int> debtId,
      Value<int> number,
      Value<DateTime> dueDate,
      Value<int> amountCents,
      Value<DateTime?> paidAt,
    });

final class $$DebtInstallmentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DebtInstallmentsTable,
          DebtInstallmentRow
        > {
  $$DebtInstallmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DebtsTable _debtIdTable(_$AppDatabase db) =>
      db.debts.createAlias('debt_installments__debt_id__debts__id');

  $$DebtsTableProcessedTableManager get debtId {
    final $_column = $_itemColumn<int>('debt_id')!;

    final manager = $$DebtsTableTableManager(
      $_db,
      $_db.debts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_debtIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DebtInstallmentsTableFilterComposer
    extends Composer<_$AppDatabase, $DebtInstallmentsTable> {
  $$DebtInstallmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DebtsTableFilterComposer get debtId {
    final $$DebtsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.debtId,
      referencedTable: $db.debts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DebtsTableFilterComposer(
            $db: $db,
            $table: $db.debts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DebtInstallmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DebtInstallmentsTable> {
  $$DebtInstallmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DebtsTableOrderingComposer get debtId {
    final $$DebtsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.debtId,
      referencedTable: $db.debts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DebtsTableOrderingComposer(
            $db: $db,
            $table: $db.debts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DebtInstallmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebtInstallmentsTable> {
  $$DebtInstallmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  $$DebtsTableAnnotationComposer get debtId {
    final $$DebtsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.debtId,
      referencedTable: $db.debts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DebtsTableAnnotationComposer(
            $db: $db,
            $table: $db.debts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DebtInstallmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DebtInstallmentsTable,
          DebtInstallmentRow,
          $$DebtInstallmentsTableFilterComposer,
          $$DebtInstallmentsTableOrderingComposer,
          $$DebtInstallmentsTableAnnotationComposer,
          $$DebtInstallmentsTableCreateCompanionBuilder,
          $$DebtInstallmentsTableUpdateCompanionBuilder,
          (DebtInstallmentRow, $$DebtInstallmentsTableReferences),
          DebtInstallmentRow,
          PrefetchHooks Function({bool debtId})
        > {
  $$DebtInstallmentsTableTableManager(
    _$AppDatabase db,
    $DebtInstallmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebtInstallmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebtInstallmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebtInstallmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> debtId = const Value.absent(),
                Value<int> number = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<DateTime?> paidAt = const Value.absent(),
              }) => DebtInstallmentsCompanion(
                id: id,
                debtId: debtId,
                number: number,
                dueDate: dueDate,
                amountCents: amountCents,
                paidAt: paidAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int debtId,
                required int number,
                required DateTime dueDate,
                required int amountCents,
                Value<DateTime?> paidAt = const Value.absent(),
              }) => DebtInstallmentsCompanion.insert(
                id: id,
                debtId: debtId,
                number: number,
                dueDate: dueDate,
                amountCents: amountCents,
                paidAt: paidAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DebtInstallmentsTable, DebtInstallmentRow>(
                    table,
                  ),
                  $$DebtInstallmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({debtId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (debtId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.debtId,
                        referencedTable: $$DebtInstallmentsTableReferences
                            ._debtIdTable(db),
                        referencedColumn: $$DebtInstallmentsTableReferences
                            ._debtIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DebtInstallmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DebtInstallmentsTable,
      DebtInstallmentRow,
      $$DebtInstallmentsTableFilterComposer,
      $$DebtInstallmentsTableOrderingComposer,
      $$DebtInstallmentsTableAnnotationComposer,
      $$DebtInstallmentsTableCreateCompanionBuilder,
      $$DebtInstallmentsTableUpdateCompanionBuilder,
      (DebtInstallmentRow, $$DebtInstallmentsTableReferences),
      DebtInstallmentRow,
      PrefetchHooks Function({bool debtId})
    >;
typedef $$CardPurchasesTableCreateCompanionBuilder =
    CardPurchasesCompanion Function({
      Value<int> id,
      required int cardId,
      required String description,
      required int totalCents,
      required DateTime purchaseDate,
      required int installmentCount,
    });
typedef $$CardPurchasesTableUpdateCompanionBuilder =
    CardPurchasesCompanion Function({
      Value<int> id,
      Value<int> cardId,
      Value<String> description,
      Value<int> totalCents,
      Value<DateTime> purchaseDate,
      Value<int> installmentCount,
    });

final class $$CardPurchasesTableReferences
    extends
        BaseReferences<_$AppDatabase, $CardPurchasesTable, CardPurchaseRow> {
  $$CardPurchasesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CreditCardsTable _cardIdTable(_$AppDatabase db) =>
      db.creditCards.createAlias('card_purchases__card_id__credit_cards__id');

  $$CreditCardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<int>('card_id')!;

    final manager = $$CreditCardsTableTableManager(
      $_db,
      $_db.creditCards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $CardPurchaseInstallmentsTable,
    List<CardPurchaseInstallmentRow>
  >
  _cardPurchaseInstallmentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.cardPurchaseInstallments,
        aliasName:
            'card_purchases__id__card_purchase_installments__purchase_id',
      );

  $$CardPurchaseInstallmentsTableProcessedTableManager
  get cardPurchaseInstallmentsRefs {
    final manager = $$CardPurchaseInstallmentsTableTableManager(
      $_db,
      $_db.cardPurchaseInstallments,
    ).filter((f) => f.purchaseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cardPurchaseInstallmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CardPurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $CardPurchasesTable> {
  $$CardPurchasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCents => $composableBuilder(
    column: $table.totalCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get installmentCount => $composableBuilder(
    column: $table.installmentCount,
    builder: (column) => ColumnFilters(column),
  );

  $$CreditCardsTableFilterComposer get cardId {
    final $$CreditCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableFilterComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> cardPurchaseInstallmentsRefs(
    Expression<bool> Function($$CardPurchaseInstallmentsTableFilterComposer f)
    f,
  ) {
    final $$CardPurchaseInstallmentsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.cardPurchaseInstallments,
          getReferencedColumn: (t) => t.purchaseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CardPurchaseInstallmentsTableFilterComposer(
                $db: $db,
                $table: $db.cardPurchaseInstallments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CardPurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $CardPurchasesTable> {
  $$CardPurchasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCents => $composableBuilder(
    column: $table.totalCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get installmentCount => $composableBuilder(
    column: $table.installmentCount,
    builder: (column) => ColumnOrderings(column),
  );

  $$CreditCardsTableOrderingComposer get cardId {
    final $$CreditCardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableOrderingComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardPurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardPurchasesTable> {
  $$CardPurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalCents => $composableBuilder(
    column: $table.totalCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get installmentCount => $composableBuilder(
    column: $table.installmentCount,
    builder: (column) => column,
  );

  $$CreditCardsTableAnnotationComposer get cardId {
    final $$CreditCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> cardPurchaseInstallmentsRefs<T extends Object>(
    Expression<T> Function($$CardPurchaseInstallmentsTableAnnotationComposer a)
    f,
  ) {
    final $$CardPurchaseInstallmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.cardPurchaseInstallments,
          getReferencedColumn: (t) => t.purchaseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CardPurchaseInstallmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.cardPurchaseInstallments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CardPurchasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardPurchasesTable,
          CardPurchaseRow,
          $$CardPurchasesTableFilterComposer,
          $$CardPurchasesTableOrderingComposer,
          $$CardPurchasesTableAnnotationComposer,
          $$CardPurchasesTableCreateCompanionBuilder,
          $$CardPurchasesTableUpdateCompanionBuilder,
          (CardPurchaseRow, $$CardPurchasesTableReferences),
          CardPurchaseRow,
          PrefetchHooks Function({
            bool cardId,
            bool cardPurchaseInstallmentsRefs,
          })
        > {
  $$CardPurchasesTableTableManager(_$AppDatabase db, $CardPurchasesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardPurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardPurchasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardPurchasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cardId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> totalCents = const Value.absent(),
                Value<DateTime> purchaseDate = const Value.absent(),
                Value<int> installmentCount = const Value.absent(),
              }) => CardPurchasesCompanion(
                id: id,
                cardId: cardId,
                description: description,
                totalCents: totalCents,
                purchaseDate: purchaseDate,
                installmentCount: installmentCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cardId,
                required String description,
                required int totalCents,
                required DateTime purchaseDate,
                required int installmentCount,
              }) => CardPurchasesCompanion.insert(
                id: id,
                cardId: cardId,
                description: description,
                totalCents: totalCents,
                purchaseDate: purchaseDate,
                installmentCount: installmentCount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CardPurchasesTable, CardPurchaseRow>(table),
                  $$CardPurchasesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({cardId = false, cardPurchaseInstallmentsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (cardPurchaseInstallmentsRefs)
                      db.cardPurchaseInstallments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (cardId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.cardId,
                            referencedTable: $$CardPurchasesTableReferences
                                ._cardIdTable(db),
                            referencedColumn: $$CardPurchasesTableReferences
                                ._cardIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (cardPurchaseInstallmentsRefs)
                        await $_getPrefetchedData<
                          CardPurchaseRow,
                          $CardPurchasesTable,
                          CardPurchaseInstallmentRow
                        >(
                          currentTable: table,
                          referencedTable: $$CardPurchasesTableReferences
                              ._cardPurchaseInstallmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CardPurchasesTableReferences(
                                db,
                                table,
                                p0,
                              ).cardPurchaseInstallmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.purchaseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CardPurchasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardPurchasesTable,
      CardPurchaseRow,
      $$CardPurchasesTableFilterComposer,
      $$CardPurchasesTableOrderingComposer,
      $$CardPurchasesTableAnnotationComposer,
      $$CardPurchasesTableCreateCompanionBuilder,
      $$CardPurchasesTableUpdateCompanionBuilder,
      (CardPurchaseRow, $$CardPurchasesTableReferences),
      CardPurchaseRow,
      PrefetchHooks Function({bool cardId, bool cardPurchaseInstallmentsRefs})
    >;
typedef $$CardPurchaseInstallmentsTableCreateCompanionBuilder =
    CardPurchaseInstallmentsCompanion Function({
      Value<int> id,
      required int purchaseId,
      required int number,
      required int invoiceMonth,
      required int amountCents,
    });
typedef $$CardPurchaseInstallmentsTableUpdateCompanionBuilder =
    CardPurchaseInstallmentsCompanion Function({
      Value<int> id,
      Value<int> purchaseId,
      Value<int> number,
      Value<int> invoiceMonth,
      Value<int> amountCents,
    });

final class $$CardPurchaseInstallmentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CardPurchaseInstallmentsTable,
          CardPurchaseInstallmentRow
        > {
  $$CardPurchaseInstallmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CardPurchasesTable _purchaseIdTable(_$AppDatabase db) =>
      db.cardPurchases.createAlias(
        'card_purchase_installments__purchase_id__card_purchases__id',
      );

  $$CardPurchasesTableProcessedTableManager get purchaseId {
    final $_column = $_itemColumn<int>('purchase_id')!;

    final manager = $$CardPurchasesTableTableManager(
      $_db,
      $_db.cardPurchases,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_purchaseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CardPurchaseInstallmentsTableFilterComposer
    extends Composer<_$AppDatabase, $CardPurchaseInstallmentsTable> {
  $$CardPurchaseInstallmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get invoiceMonth => $composableBuilder(
    column: $table.invoiceMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  $$CardPurchasesTableFilterComposer get purchaseId {
    final $$CardPurchasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseId,
      referencedTable: $db.cardPurchases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardPurchasesTableFilterComposer(
            $db: $db,
            $table: $db.cardPurchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardPurchaseInstallmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardPurchaseInstallmentsTable> {
  $$CardPurchaseInstallmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get invoiceMonth => $composableBuilder(
    column: $table.invoiceMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  $$CardPurchasesTableOrderingComposer get purchaseId {
    final $$CardPurchasesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseId,
      referencedTable: $db.cardPurchases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardPurchasesTableOrderingComposer(
            $db: $db,
            $table: $db.cardPurchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardPurchaseInstallmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardPurchaseInstallmentsTable> {
  $$CardPurchaseInstallmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<int> get invoiceMonth => $composableBuilder(
    column: $table.invoiceMonth,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  $$CardPurchasesTableAnnotationComposer get purchaseId {
    final $$CardPurchasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseId,
      referencedTable: $db.cardPurchases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardPurchasesTableAnnotationComposer(
            $db: $db,
            $table: $db.cardPurchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardPurchaseInstallmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardPurchaseInstallmentsTable,
          CardPurchaseInstallmentRow,
          $$CardPurchaseInstallmentsTableFilterComposer,
          $$CardPurchaseInstallmentsTableOrderingComposer,
          $$CardPurchaseInstallmentsTableAnnotationComposer,
          $$CardPurchaseInstallmentsTableCreateCompanionBuilder,
          $$CardPurchaseInstallmentsTableUpdateCompanionBuilder,
          (
            CardPurchaseInstallmentRow,
            $$CardPurchaseInstallmentsTableReferences,
          ),
          CardPurchaseInstallmentRow,
          PrefetchHooks Function({bool purchaseId})
        > {
  $$CardPurchaseInstallmentsTableTableManager(
    _$AppDatabase db,
    $CardPurchaseInstallmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardPurchaseInstallmentsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CardPurchaseInstallmentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CardPurchaseInstallmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> purchaseId = const Value.absent(),
                Value<int> number = const Value.absent(),
                Value<int> invoiceMonth = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
              }) => CardPurchaseInstallmentsCompanion(
                id: id,
                purchaseId: purchaseId,
                number: number,
                invoiceMonth: invoiceMonth,
                amountCents: amountCents,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int purchaseId,
                required int number,
                required int invoiceMonth,
                required int amountCents,
              }) => CardPurchaseInstallmentsCompanion.insert(
                id: id,
                purchaseId: purchaseId,
                number: number,
                invoiceMonth: invoiceMonth,
                amountCents: amountCents,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $CardPurchaseInstallmentsTable,
                    CardPurchaseInstallmentRow
                  >(table),
                  $$CardPurchaseInstallmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({purchaseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (purchaseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.purchaseId,
                        referencedTable:
                            $$CardPurchaseInstallmentsTableReferences
                                ._purchaseIdTable(db),
                        referencedColumn:
                            $$CardPurchaseInstallmentsTableReferences
                                ._purchaseIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CardPurchaseInstallmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardPurchaseInstallmentsTable,
      CardPurchaseInstallmentRow,
      $$CardPurchaseInstallmentsTableFilterComposer,
      $$CardPurchaseInstallmentsTableOrderingComposer,
      $$CardPurchaseInstallmentsTableAnnotationComposer,
      $$CardPurchaseInstallmentsTableCreateCompanionBuilder,
      $$CardPurchaseInstallmentsTableUpdateCompanionBuilder,
      (CardPurchaseInstallmentRow, $$CardPurchaseInstallmentsTableReferences),
      CardPurchaseInstallmentRow,
      PrefetchHooks Function({bool purchaseId})
    >;
typedef $$OneOffEntriesTableCreateCompanionBuilder =
    OneOffEntriesCompanion Function({
      Value<int> id,
      required EntryKind kind,
      required String description,
      required int amountCents,
      required DateTime date,
      Value<DateTime?> paidAt,
    });
typedef $$OneOffEntriesTableUpdateCompanionBuilder =
    OneOffEntriesCompanion Function({
      Value<int> id,
      Value<EntryKind> kind,
      Value<String> description,
      Value<int> amountCents,
      Value<DateTime> date,
      Value<DateTime?> paidAt,
    });

class $$OneOffEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $OneOffEntriesTable> {
  $$OneOffEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EntryKind, EntryKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OneOffEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $OneOffEntriesTable> {
  $$OneOffEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OneOffEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OneOffEntriesTable> {
  $$OneOffEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EntryKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);
}

class $$OneOffEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OneOffEntriesTable,
          OneOffEntryRow,
          $$OneOffEntriesTableFilterComposer,
          $$OneOffEntriesTableOrderingComposer,
          $$OneOffEntriesTableAnnotationComposer,
          $$OneOffEntriesTableCreateCompanionBuilder,
          $$OneOffEntriesTableUpdateCompanionBuilder,
          (
            OneOffEntryRow,
            BaseReferences<_$AppDatabase, $OneOffEntriesTable, OneOffEntryRow>,
          ),
          OneOffEntryRow,
          PrefetchHooks Function()
        > {
  $$OneOffEntriesTableTableManager(_$AppDatabase db, $OneOffEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OneOffEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OneOffEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OneOffEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<EntryKind> kind = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime?> paidAt = const Value.absent(),
              }) => OneOffEntriesCompanion(
                id: id,
                kind: kind,
                description: description,
                amountCents: amountCents,
                date: date,
                paidAt: paidAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required EntryKind kind,
                required String description,
                required int amountCents,
                required DateTime date,
                Value<DateTime?> paidAt = const Value.absent(),
              }) => OneOffEntriesCompanion.insert(
                id: id,
                kind: kind,
                description: description,
                amountCents: amountCents,
                date: date,
                paidAt: paidAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OneOffEntriesTable, OneOffEntryRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $OneOffEntriesTable,
                    OneOffEntryRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OneOffEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OneOffEntriesTable,
      OneOffEntryRow,
      $$OneOffEntriesTableFilterComposer,
      $$OneOffEntriesTableOrderingComposer,
      $$OneOffEntriesTableAnnotationComposer,
      $$OneOffEntriesTableCreateCompanionBuilder,
      $$OneOffEntriesTableUpdateCompanionBuilder,
      (
        OneOffEntryRow,
        BaseReferences<_$AppDatabase, $OneOffEntriesTable, OneOffEntryRow>,
      ),
      OneOffEntryRow,
      PrefetchHooks Function()
    >;
typedef $$MonthlyRecordsTableCreateCompanionBuilder =
    MonthlyRecordsCompanion Function({
      Value<int> id,
      required RecordSource sourceType,
      required int sourceId,
      required int month,
      Value<int?> amountOverrideCents,
      Value<DateTime?> paidAt,
    });
typedef $$MonthlyRecordsTableUpdateCompanionBuilder =
    MonthlyRecordsCompanion Function({
      Value<int> id,
      Value<RecordSource> sourceType,
      Value<int> sourceId,
      Value<int> month,
      Value<int?> amountOverrideCents,
      Value<DateTime?> paidAt,
    });

class $$MonthlyRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $MonthlyRecordsTable> {
  $$MonthlyRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RecordSource, RecordSource, String>
  get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountOverrideCents => $composableBuilder(
    column: $table.amountOverrideCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MonthlyRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $MonthlyRecordsTable> {
  $$MonthlyRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountOverrideCents => $composableBuilder(
    column: $table.amountOverrideCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MonthlyRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonthlyRecordsTable> {
  $$MonthlyRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RecordSource, String> get sourceType =>
      $composableBuilder(
        column: $table.sourceType,
        builder: (column) => column,
      );

  GeneratedColumn<int> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get amountOverrideCents => $composableBuilder(
    column: $table.amountOverrideCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);
}

class $$MonthlyRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MonthlyRecordsTable,
          MonthlyRecordRow,
          $$MonthlyRecordsTableFilterComposer,
          $$MonthlyRecordsTableOrderingComposer,
          $$MonthlyRecordsTableAnnotationComposer,
          $$MonthlyRecordsTableCreateCompanionBuilder,
          $$MonthlyRecordsTableUpdateCompanionBuilder,
          (
            MonthlyRecordRow,
            BaseReferences<
              _$AppDatabase,
              $MonthlyRecordsTable,
              MonthlyRecordRow
            >,
          ),
          MonthlyRecordRow,
          PrefetchHooks Function()
        > {
  $$MonthlyRecordsTableTableManager(
    _$AppDatabase db,
    $MonthlyRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonthlyRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonthlyRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonthlyRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<RecordSource> sourceType = const Value.absent(),
                Value<int> sourceId = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<int?> amountOverrideCents = const Value.absent(),
                Value<DateTime?> paidAt = const Value.absent(),
              }) => MonthlyRecordsCompanion(
                id: id,
                sourceType: sourceType,
                sourceId: sourceId,
                month: month,
                amountOverrideCents: amountOverrideCents,
                paidAt: paidAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required RecordSource sourceType,
                required int sourceId,
                required int month,
                Value<int?> amountOverrideCents = const Value.absent(),
                Value<DateTime?> paidAt = const Value.absent(),
              }) => MonthlyRecordsCompanion.insert(
                id: id,
                sourceType: sourceType,
                sourceId: sourceId,
                month: month,
                amountOverrideCents: amountOverrideCents,
                paidAt: paidAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MonthlyRecordsTable, MonthlyRecordRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MonthlyRecordsTable,
                    MonthlyRecordRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MonthlyRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MonthlyRecordsTable,
      MonthlyRecordRow,
      $$MonthlyRecordsTableFilterComposer,
      $$MonthlyRecordsTableOrderingComposer,
      $$MonthlyRecordsTableAnnotationComposer,
      $$MonthlyRecordsTableCreateCompanionBuilder,
      $$MonthlyRecordsTableUpdateCompanionBuilder,
      (
        MonthlyRecordRow,
        BaseReferences<_$AppDatabase, $MonthlyRecordsTable, MonthlyRecordRow>,
      ),
      MonthlyRecordRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CreditCardsTableTableManager get creditCards =>
      $$CreditCardsTableTableManager(_db, _db.creditCards);
  $$IncomesTableTableManager get incomes =>
      $$IncomesTableTableManager(_db, _db.incomes);
  $$FixedExpensesTableTableManager get fixedExpenses =>
      $$FixedExpensesTableTableManager(_db, _db.fixedExpenses);
  $$DebtsTableTableManager get debts =>
      $$DebtsTableTableManager(_db, _db.debts);
  $$DebtInstallmentsTableTableManager get debtInstallments =>
      $$DebtInstallmentsTableTableManager(_db, _db.debtInstallments);
  $$CardPurchasesTableTableManager get cardPurchases =>
      $$CardPurchasesTableTableManager(_db, _db.cardPurchases);
  $$CardPurchaseInstallmentsTableTableManager get cardPurchaseInstallments =>
      $$CardPurchaseInstallmentsTableTableManager(
        _db,
        _db.cardPurchaseInstallments,
      );
  $$OneOffEntriesTableTableManager get oneOffEntries =>
      $$OneOffEntriesTableTableManager(_db, _db.oneOffEntries);
  $$MonthlyRecordsTableTableManager get monthlyRecords =>
      $$MonthlyRecordsTableTableManager(_db, _db.monthlyRecords);
}

/*==============================================================*/
/* DBMS name:      PostgreSQL 9.x                               */
/* Created on:     30/06/2024 16:43:57                          */
/*==============================================================*/


DROP TABLE ACCOUNT;

DROP TABLE COMMISSION;

DROP TABLE COMPANY;

DROP TABLE INVOICE;

DROP TABLE INVOICE_TAX_DETAIL;

DROP TABLE "ORDER";

DROP TABLE ORDER_ITEM;

DROP TABLE PAYMENT_RECORD;

DROP TABLE RECEIVABLE;

DROP TABLE RECEIVABLE_COMMISSION;

DROP TABLE RECIPIENT;

/*==============================================================*/
/* Table: ACCOUNT                                               */
/*==============================================================*/
CREATE TABLE ACCOUNT (
   ACCOUNT_ID           SERIAL NOT NULL,
   COMPANY_ID           INT4                 NULL,
   CODE_UNIQUE_ACCOUNT  VARCHAR(32)          NULL,
   NUMBER               VARCHAR(10)          NULL,
   TYPE                 VARCHAR(3)           NULL
      CONSTRAINT CKC_TYPE_ACCOUNT CHECK (TYPE IS NULL OR (TYPE IN ('COR','AHO'))),
   STATUS               VARCHAR(3)           NULL
      CONSTRAINT CKC_STATUS_ACCOUNT CHECK (STATUS IS NULL OR (STATUS IN ('ACT','INA','BLO','<Val3>'))),
   CONSTRAINT PK_CYR_ACCOUNT PRIMARY KEY (ACCOUNT_ID)
);

/*==============================================================*/
/* Table: COMMISSION                                            */
/*==============================================================*/
CREATE TABLE COMMISSION (
   COMMISSION_ID        SERIAL NOT NULL,
   INVOICE_ID           INT4                 NULL,
   NAME                 VARCHAR(100)         NULL,
   CHARGE_DISTRIBUTION  VARCHAR(3)           NULL
      CONSTRAINT CKC_DISTRIBUTION_CHARG_CYR_COMM CHECK (CHARGE_DISTRIBUTION IS NULL OR (CHARGE_DISTRIBUTION IN ('TOE','PAR','ALL'))),
   TOTAL_VALUE          NUMERIC(17,2)        NULL,
   COMPANY_VALUE        NUMERIC(17,2)        NULL,
   DEBTOR_VALUE         NUMERIC(17,2)        NULL,
   CREDITOR_ACCOUNT     VARCHAR(13)          NULL,
   CONSTRAINT PK_CYR_COMMISSION PRIMARY KEY (COMMISSION_ID)
);

/*==============================================================*/
/* Table: COMPANY                                               */
/*==============================================================*/
CREATE TABLE COMPANY (
   COMPANY_ID           SERIAL NOT NULL,
   RUC                  VARCHAR(20)          NULL,
   COMPANY_NAME         VARCHAR(100)         NOT NULL,
   LEGAL_REPRESENTATIVE VARCHAR(100)         NOT NULL,
   SRI_AUTHORIZATION    BOOLEAN              NOT NULL,
   CONTRACT_ACCEPTANCE  BOOLEAN              NOT NULL,
   CONSTRAINT PK_CYR_COMPANY PRIMARY KEY (COMPANY_ID)
);

/*==============================================================*/
/* Table: INVOICE                                               */
/*==============================================================*/
CREATE TABLE INVOICE (
   INVOICE_ID           SERIAL NOT NULL,
   SEQUENTIAL           VARCHAR(20)          NOT NULL,
   AUTHORIZATION_NUMBER VARCHAR(40)          NOT NULL,
   DATE                 TIMESTAMP            NOT NULL,
   SUBTOTAL             NUMERIC(17,2)        NOT NULL,
   TOTAL                NUMERIC(17,2)        NOT NULL,
   CONSTRAINT PK_CYR_INVOICE PRIMARY KEY (INVOICE_ID)
);

/*==============================================================*/
/* Table: INVOICE_TAX_DETAIL                                    */
/*==============================================================*/
CREATE TABLE INVOICE_TAX_DETAIL (
   INVOICE_TAX_DETAIL_ID SERIAL NOT NULL,
   INVOICE_ID           INT4                 NOT NULL,
   NAME                 VARCHAR(50)          NOT NULL,
   VALUE                NUMERIC(17,2)        NOT NULL,
   PERCENTAGE           NUMERIC(17,2)        NOT NULL,
   CONSTRAINT PK_CYR_INVOICE_TAX_DETAIL PRIMARY KEY (INVOICE_TAX_DETAIL_ID)
);

/*==============================================================*/
/* Table: "ORDER"                                               */
/*==============================================================*/
CREATE TABLE "ORDER" (
   ORDER_ID             SERIAL NOT NULL,
   RECEIVABLE_ID        INT                  NULL,
   START_DATE           DATE                 NULL,
   DUE_DATE             DATE                 NULL,
   TOTAL_AMOUNT         NUMERIC(17,2)        NULL,
   RECORDS              VARCHAR(6)           NULL,
   DESCRIPTION          VARCHAR(100)         NULL,
   STATUS               VARCHAR(3)           NULL
      CONSTRAINT CKC_STATUS_ORDER CHECK (STATUS IS NULL OR (STATUS IN ('PEN','PRO'))),
   COLUMN_9             CHAR(10)             NULL,
   COMMISSION           CHAR(10)             NULL,
   CONSTRAINT PK_CYR_ORDER PRIMARY KEY (ORDER_ID)
);

/*==============================================================*/
/* Table: ORDER_ITEM                                            */
/*==============================================================*/
CREATE TABLE ORDER_ITEM (
   ORDER_ITEM_ID        SERIAL NOT NULL,
   ORDER_ID             INT4                 NULL,
   DEBTOR_NAME          VARCHAR(100)         NULL,
   IDENTIFICATION_TYPE  VARCHAR(3)           NULL
      CONSTRAINT CKC_IDENTIFICATION_TY_ORDER_IT CHECK (IDENTIFICATION_TYPE IS NULL OR (IDENTIFICATION_TYPE IN ('CED','PAS','RUC'))),
   IDENTIFICATION       VARCHAR(20)          NULL,
   DEBIT_ACCOUNT        VARCHAR(10)          NULL,
   OWED_AMOUNT          NUMERIC(17,2)        NULL,
   COUNTERPART          VARCHAR(10)          NULL,
   STATUS               VARCHAR(3)           NULL
      CONSTRAINT CKC_STATUS_ORDER_IT CHECK (STATUS IS NULL OR (STATUS IN ('EXP','PAG'))),
   CONSTRAINT PK_CYR_ORDER_ITEMS PRIMARY KEY (ORDER_ITEM_ID)
);

/*==============================================================*/
/* Table: PAYMENT_RECORD                                        */
/*==============================================================*/
CREATE TABLE PAYMENT_RECORD (
   PAYMENT_RECORD_ID    SERIAL NOT NULL,
   ORDER_ITEM_ID        INT4                 NULL,
   PAYMENT_TYPE         VARCHAR(3)           NULL
      CONSTRAINT CKC_PAYMENT_TYPE_PAYMENT_ CHECK (PAYMENT_TYPE IS NULL OR (PAYMENT_TYPE IN ('EFE','TAR'))),
   OWED_PAYMENT         NUMERIC(17,2)        NULL,
   PAYMENT_DATE         TIMESTAMP            NULL,
   OUTSTANDING_BALANCE  NUMERIC(17,2)        NULL,
   CHANNEL              VARCHAR(3)           NULL
      CONSTRAINT CKC_CHANNEL_CYR_PAYMENT CHECK (CHANNEL IS NULL OR (CHANNEL IN ('BNW','VEN','ATM'))),
   CONSTRAINT PK_CYR_PAYMENT_RECORD PRIMARY KEY (PAYMENT_RECORD_ID)
);

/*==============================================================*/
/* Table: RECEIVABLE                                            */
/*==============================================================*/
CREATE TABLE RECEIVABLE (
   RECEIVABLE_ID        SERIAL NOT NULL,
   COMPANY_ID           INT                  NULL,
   ACCOUNT_ID           INT                  NULL,
   TYPE                 VARCHAR(3)           NULL
      CONSTRAINT CKC_TYPE_RECEIVAB CHECK (TYPE IS NULL OR (TYPE IN ('COB','REC'))),
   NAME                 VARCHAR(100)         NULL,
   DATE                 TIMESTAMP            NULL,
   CONSTRAINT PK_CYR_COLLECTION PRIMARY KEY (RECEIVABLE_ID)
);

/*==============================================================*/
/* Table: RECEIVABLE_COMMISSION                                 */
/*==============================================================*/
CREATE TABLE RECEIVABLE_COMMISSION (
   RECEIVABLE_COMMISSION_ID SERIAL NOT NULL,
   RECEIVABLE_ID        INT4                 NULL,
   COMMISSION_ID        INT4                 NULL,
   CONSTRAINT PK_CYR_COLL_COM PRIMARY KEY (RECEIVABLE_COMMISSION_ID)
);

/*==============================================================*/
/* Table: RECIPIENT                                             */
/*==============================================================*/
CREATE TABLE RECIPIENT (
   RECIPIENT_ID         SERIAL NOT NULL,
   INVOICE_ID           INT4                 NULL,
   IDENTIFICATION_TYPE  VARCHAR(3)           NOT NULL
      CONSTRAINT CKC_IDENTIFICATION_TY_RECIPIEN CHECK (IDENTIFICATION_TYPE IN ('CED','PAS','RUC') AND IDENTIFICATION_TYPE = UPPER(IDENTIFICATION_TYPE)),
   IDENTIFICATION       VARCHAR(20)          NOT NULL,
   LAST_NAME            VARCHAR(50)          NULL,
   FIRST_NAME           VARCHAR(50)          NULL,
   FULL_NAME            VARCHAR(100)         NULL,
   LEGAL_NAME           VARCHAR(100)         NULL,
   ADDRESS              VARCHAR(100)         NOT NULL,
   PHONE                VARCHAR(15)          NOT NULL,
   EMAIL                VARCHAR(100)         NOT NULL,
   CONSTRAINT PK_CYR_RECIPIENT PRIMARY KEY (RECIPIENT_ID)
);

ALTER TABLE ACCOUNT
   ADD CONSTRAINT FK_ACCOUNT_REFERENCE_COMPANY FOREIGN KEY (COMPANY_ID)
      REFERENCES COMPANY (COMPANY_ID)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE COMMISSION
   ADD CONSTRAINT FK_COMMISSI_REFERENCE_INVOICE FOREIGN KEY (INVOICE_ID)
      REFERENCES INVOICE (INVOICE_ID)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE INVOICE_TAX_DETAIL
   ADD CONSTRAINT FK_INVOICE__REFERENCE_INVOICE FOREIGN KEY (INVOICE_ID)
      REFERENCES INVOICE (INVOICE_ID)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE "ORDER"
   ADD CONSTRAINT FK_CYR_ORDE_REFERENCE_CYR_COLL FOREIGN KEY (RECEIVABLE_ID)
      REFERENCES RECEIVABLE (RECEIVABLE_ID)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE ORDER_ITEM
   ADD CONSTRAINT FK_CYR_ORDER_REFERENCE_CYR_ORDE FOREIGN KEY (ORDER_ID)
      REFERENCES "ORDER" (ORDER_ID)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE PAYMENT_RECORD
   ADD CONSTRAINT FK_CYR_PAYM_REFERENCE_CYR_ORDE FOREIGN KEY (ORDER_ITEM_ID)
      REFERENCES ORDER_ITEM (ORDER_ITEM_ID)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE RECEIVABLE
   ADD CONSTRAINT FK_CYR_COLL_REFERENCE_CYR_ACCO FOREIGN KEY (ACCOUNT_ID)
      REFERENCES ACCOUNT (ACCOUNT_ID)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE RECEIVABLE
   ADD CONSTRAINT FK_CYR_COLL_REFERENCE_CYR_COMP FOREIGN KEY (COMPANY_ID)
      REFERENCES COMPANY (COMPANY_ID)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE RECEIVABLE_COMMISSION
   ADD CONSTRAINT FK_CYR_COLL_REFERENCE_CYR_COMM FOREIGN KEY (COMMISSION_ID)
      REFERENCES COMMISSION (COMMISSION_ID)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE RECEIVABLE_COMMISSION
   ADD CONSTRAINT FK_CYR_COLL_REFERENCE_CYR_COLL FOREIGN KEY (RECEIVABLE_ID)
      REFERENCES RECEIVABLE (RECEIVABLE_ID)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE RECIPIENT
   ADD CONSTRAINT FK_CYR_RECI_REFERENCE_CYR_INVO FOREIGN KEY (INVOICE_ID)
      REFERENCES INVOICE (INVOICE_ID)
      ON DELETE RESTRICT ON UPDATE RESTRICT;


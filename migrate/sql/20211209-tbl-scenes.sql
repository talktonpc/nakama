/*
 * Copyright 2021 The Nakama Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

-- +migrate Up
DROP TABLE IF EXISTS tbl_scenes;

-- ================================================================================================================
-- Added for MetaTop extension (2021-12-09, lonycell)
-- ================================================================================================================
CREATE TABLE IF NOT EXISTS tbl_scenes (
    PRIMARY KEY (id),

    id      INTEGER         NOT NULL UNIQUE CHECK (id >= 0),
    type    SMALLINT        NOT NULL DEFAULT 0 CHECK (type >= 0), -- continent(0), city(1), building(2), room(3), interior(4)
    name    VARCHAR(255)    NOT NULL UNIQUE,
    title   VARCHAR(255)    NOT NULL,
    address VARCHAR(255),
    thumb   VARCHAR(255),
    minimap VARCHAR(255),
    scale   float(2) DEFAULT 1.0 CHECK (scale >= 0.0),
    create_time TIMESTAMPTZ  NOT NULL DEFAULT now(),
    update_time TIMESTAMPTZ  NOT NULL DEFAULT now()
);

INSERT INTO tbl_scenes (id, type, name, title, address, thumb, minimap, scale) VALUES
    (1,1,'Simple_City_1','에듀 월드','서울특별시 강남구 역삼동','city1','SimpleCity',1.25),
    (2,4,'Simple_Shop_Clothing_1','지오다노 서초점','서울특별시 서초구 서초동 1306-1','','',1.25),
    (3,4,'Simple_CramSchool_1','산타토익','서울특별시 서초구 서초동 1306-1','','',2),
    (4,4,'Simple_Shop_Arcade_1','레전드히어로즈 강남역점','서울특별시 서초구 서초동 1317-31','','',1.25),
    (5,4,'SimpleHouse_1','강남역 롯데캐슬','서울특별시 강남구 역삼동 135번지, A동 3004호','','',1.25),
    (6,4,'Simple_House_1','서초동 레미안','서울특별시 강남구 서초동 135번지, 가동 104호','','',1.25),
    (7,4,'Simple_Shop_Music_1','VNYL & PLASTIC','서울특별시 강남구 역삼동 유탑빌딩','','',1.25),
    (8,4,'Simple_Office_1','유탑소프트','서울특별시 강남구 대치동','','',1.25),
    (9,4,'SimpleOffice_1','유탑소프트 (연구소)','서울특별시 강남구 대치동','','',1.25),
    (10,4,'Simple_Shop_Mall_1','홈플러스 서초점','서울특별시 강남구 삼성동','','',1.25),
    (11,4,'Simple_Shop_Bakery_1','파리바게뜨 서초점','서울특별시 서초구 서초동','','',1.25),
    (12,4,'Simple_Shop_Luxury_1','유탑소프트','서울특별시 강남구 언주로','','',1.25),
    (13,4,'Simple_Shop_Mall_2','롯데 백화점 1층','서울특별시 강남구 삼성동','','',1.25),
    (14,4,'Simple_Shop_Fastfood_1','롯데리아 강남점','서울특별시 강남구 삼성동','','',1.25),
    (15,4,'Home_XI_1','서초 자이 A동','서울특별시 강남구 서초동','','',1.5),
    (16,4,'Home_XI_2','서초 자이 B동','서울특별시 강남구 서초동','','',1.25),
    (17,4,'Home_XI_3','서초 자이 C동','서울특별시 강남구 서초동','','',2),
    (18,4,'Hansol_Display','한솔 교육','서울특별시 마포구 상암동','','',1.25),
    (19,4,'Ruiiid_office','뤼이드 본사','서울특별시 강남구 삼성동','','',1.7),
    (20,4,'Ruiiid_Class','뤼이드 클래스','서울특별시 강남구 삼성동','','',1.25),
    (21,4,'UTOP_Office','유탑 소프트','서울특별시 강남구 대치동','','',1.25),
    (22,1,'Simple_City_2','여주역 휴먼빌','경기도 여주시 교동','city2','SimpleCity',2),
    (23,4,'Modelhouse_59','여주역 휴먼빌 (59)','경기도 여주시 교동','','',1.25),
    (24,4,'Modelhouse_84','여주역 휴먼빌 (84)','경기도 여주시 교동','','',1.25),
    (25,4,'Simple_Shop_Starbucks','스타벅스 서초점','서울특별시 서초구 서초동 1317-31','','',1.25),
    (26,4,'daekyo_office','대교타워 10층','서울시 관악구 보라매로 3길 23','','',1.25),
    (27,1,'Simple_Park','한솔랜드','서울특별시 마포구 상암동','Park','',2),
    (28,4,'Daekyo_LC','대교 눈높이 러닝센터','서울특별시 강남구 대치동','','',1.25),
    (29,4,'Kyowon_office','교원빌딩 5층','서울특별시 종로구 종로1가','','',1.25),
    (30,4,'Namhyun','남현교회','서울특별시 구로구 경인로346','','',1.25),
    (31,4,'Starbucks_hongdae','스타벅스 홍대점','서울특별시 마포구 서교동 양화로 165','','',1.25),
    (32,4,'HB_education','해법에듀','서울특별시 금천구 가산동 가산로9길 54 ','','',1.25),
    (33,4,'Visang','비상교육','서울특별시 구로구 구로동 디지털로33길 48','','',1.25),
    (34,4,'POLY','폴리 어학원','서울시 강동구 양재대로 1553','','',1.25),
    (35,4,'YES_Yoon','윤선생 영어교실','서울특별시 서초구 서초동','','',1.25),
    (36,4,'Kyowon_Redpen','교원 빨간펜','서울특별시 강남구 도곡동','','',1.25);

-- +migrate Down
DROP TABLE IF EXISTS
    tbl_scenes;
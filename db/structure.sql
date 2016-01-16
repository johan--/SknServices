--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: content_options; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE content_options (
    id integer NOT NULL,
    content_type_id integer,
    content_type_opt_id integer
);


--
-- Name: content_options_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE content_options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: content_options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE content_options_id_seq OWNED BY content_options.id;


--
-- Name: content_profile_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE content_profile_entries (
    id integer NOT NULL,
    topic_value character varying(255),
    content_value character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description character varying(255)
);


--
-- Name: content_profile_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE content_profile_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: content_profile_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE content_profile_entries_id_seq OWNED BY content_profile_entries.id;


--
-- Name: content_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE content_profiles (
    id integer NOT NULL,
    person_authentication_key character varying(255),
    profile_type_id integer,
    authentication_provider character varying(255),
    username character varying(255),
    display_name character varying(255),
    email character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: content_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE content_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: content_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE content_profiles_id_seq OWNED BY content_profiles.id;


--
-- Name: content_type_opts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE content_type_opts (
    id integer NOT NULL,
    value character varying(255),
    description character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: content_type_opts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE content_type_opts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: content_type_opts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE content_type_opts_id_seq OWNED BY content_type_opts.id;


--
-- Name: content_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE content_types (
    id integer NOT NULL,
    name character varying(255),
    description character varying(255),
    value_data_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: content_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE content_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: content_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE content_types_id_seq OWNED BY content_types.id;


--
-- Name: join_contents; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE join_contents (
    id integer NOT NULL,
    content_profile_entry_id integer,
    content_type_id integer
);


--
-- Name: join_contents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE join_contents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: join_contents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE join_contents_id_seq OWNED BY join_contents.id;


--
-- Name: join_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE join_entries (
    id integer NOT NULL,
    content_profile_id integer,
    content_profile_entry_id integer
);


--
-- Name: join_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE join_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: join_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE join_entries_id_seq OWNED BY join_entries.id;


--
-- Name: join_topics; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE join_topics (
    id integer NOT NULL,
    content_profile_entry_id integer,
    topic_type_id integer
);


--
-- Name: join_topics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE join_topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: join_topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE join_topics_id_seq OWNED BY join_topics.id;


--
-- Name: profile_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE profile_types (
    id integer NOT NULL,
    name character varying(255),
    description character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: profile_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE profile_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: profile_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE profile_types_id_seq OWNED BY profile_types.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: topic_options; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE topic_options (
    id integer NOT NULL,
    topic_type_id integer,
    topic_type_opt_id integer
);


--
-- Name: topic_options_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE topic_options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: topic_options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE topic_options_id_seq OWNED BY topic_options.id;


--
-- Name: topic_type_opts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE topic_type_opts (
    id integer NOT NULL,
    value character varying(255),
    description character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: topic_type_opts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE topic_type_opts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: topic_type_opts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE topic_type_opts_id_seq OWNED BY topic_type_opts.id;


--
-- Name: topic_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE topic_types (
    id integer NOT NULL,
    name character varying(255),
    description character varying(255),
    value_based_y_n character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: topic_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE topic_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: topic_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE topic_types_id_seq OWNED BY topic_types.id;


--
-- Name: user_group_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_group_roles (
    id integer NOT NULL,
    name character varying(255),
    description character varying(255),
    group_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_group_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_group_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_group_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_group_roles_id_seq OWNED BY user_group_roles.id;


--
-- Name: user_group_roles_user_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_group_roles_user_roles (
    id integer NOT NULL,
    user_group_role_id integer,
    user_role_id integer
);


--
-- Name: user_group_roles_user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_group_roles_user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_group_roles_user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_group_roles_user_roles_id_seq OWNED BY user_group_roles_user_roles.id;


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_roles (
    id integer NOT NULL,
    name character varying(255),
    description character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_roles_id_seq OWNED BY user_roles.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying(255),
    name character varying(255),
    email character varying(255),
    password_digest character varying(255),
    remember_token character varying(255),
    password_reset_token character varying(255),
    password_reset_date timestamp without time zone,
    assigned_groups character varying(4096),
    roles character varying(4096),
    active boolean DEFAULT true,
    file_access_token character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    person_authenticated_key character varying(255),
    assigned_roles character varying(4096),
    remember_token_digest character varying(255),
    user_options character varying(4096)
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY content_options ALTER COLUMN id SET DEFAULT nextval('content_options_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY content_profile_entries ALTER COLUMN id SET DEFAULT nextval('content_profile_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY content_profiles ALTER COLUMN id SET DEFAULT nextval('content_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY content_type_opts ALTER COLUMN id SET DEFAULT nextval('content_type_opts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY content_types ALTER COLUMN id SET DEFAULT nextval('content_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY join_contents ALTER COLUMN id SET DEFAULT nextval('join_contents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY join_entries ALTER COLUMN id SET DEFAULT nextval('join_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY join_topics ALTER COLUMN id SET DEFAULT nextval('join_topics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY profile_types ALTER COLUMN id SET DEFAULT nextval('profile_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY topic_options ALTER COLUMN id SET DEFAULT nextval('topic_options_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY topic_type_opts ALTER COLUMN id SET DEFAULT nextval('topic_type_opts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY topic_types ALTER COLUMN id SET DEFAULT nextval('topic_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_group_roles ALTER COLUMN id SET DEFAULT nextval('user_group_roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_group_roles_user_roles ALTER COLUMN id SET DEFAULT nextval('user_group_roles_user_roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_roles ALTER COLUMN id SET DEFAULT nextval('user_roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: content_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY content_options
    ADD CONSTRAINT content_options_pkey PRIMARY KEY (id);


--
-- Name: content_profile_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY content_profile_entries
    ADD CONSTRAINT content_profile_entries_pkey PRIMARY KEY (id);


--
-- Name: content_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY content_profiles
    ADD CONSTRAINT content_profiles_pkey PRIMARY KEY (id);


--
-- Name: content_type_opts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY content_type_opts
    ADD CONSTRAINT content_type_opts_pkey PRIMARY KEY (id);


--
-- Name: content_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY content_types
    ADD CONSTRAINT content_types_pkey PRIMARY KEY (id);


--
-- Name: join_contents_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY join_contents
    ADD CONSTRAINT join_contents_pkey PRIMARY KEY (id);


--
-- Name: join_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY join_entries
    ADD CONSTRAINT join_entries_pkey PRIMARY KEY (id);


--
-- Name: join_topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY join_topics
    ADD CONSTRAINT join_topics_pkey PRIMARY KEY (id);


--
-- Name: profile_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY profile_types
    ADD CONSTRAINT profile_types_pkey PRIMARY KEY (id);


--
-- Name: topic_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY topic_options
    ADD CONSTRAINT topic_options_pkey PRIMARY KEY (id);


--
-- Name: topic_type_opts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY topic_type_opts
    ADD CONSTRAINT topic_type_opts_pkey PRIMARY KEY (id);


--
-- Name: topic_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY topic_types
    ADD CONSTRAINT topic_types_pkey PRIMARY KEY (id);


--
-- Name: user_group_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_group_roles
    ADD CONSTRAINT user_group_roles_pkey PRIMARY KEY (id);


--
-- Name: user_group_roles_user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_group_roles_user_roles
    ADD CONSTRAINT user_group_roles_user_roles_pkey PRIMARY KEY (id);


--
-- Name: user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_content_options_on_content_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_content_options_on_content_type_id ON content_options USING btree (content_type_id);


--
-- Name: index_content_options_on_content_type_opt_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_content_options_on_content_type_opt_id ON content_options USING btree (content_type_opt_id);


--
-- Name: index_content_profiles_on_person_authentication_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_content_profiles_on_person_authentication_key ON content_profiles USING btree (person_authentication_key);


--
-- Name: index_content_profiles_on_profile_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_content_profiles_on_profile_type_id ON content_profiles USING btree (profile_type_id);


--
-- Name: index_join_contents_on_content_profile_entry_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_join_contents_on_content_profile_entry_id ON join_contents USING btree (content_profile_entry_id);


--
-- Name: index_join_contents_on_content_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_join_contents_on_content_type_id ON join_contents USING btree (content_type_id);


--
-- Name: index_join_entries_on_content_profile_entry_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_join_entries_on_content_profile_entry_id ON join_entries USING btree (content_profile_entry_id);


--
-- Name: index_join_entries_on_content_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_join_entries_on_content_profile_id ON join_entries USING btree (content_profile_id);


--
-- Name: index_join_topics_on_content_profile_entry_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_join_topics_on_content_profile_entry_id ON join_topics USING btree (content_profile_entry_id);


--
-- Name: index_join_topics_on_topic_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_join_topics_on_topic_type_id ON join_topics USING btree (topic_type_id);


--
-- Name: index_topic_options_on_topic_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_topic_options_on_topic_type_id ON topic_options USING btree (topic_type_id);


--
-- Name: index_topic_options_on_topic_type_opt_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_topic_options_on_topic_type_opt_id ON topic_options USING btree (topic_type_opt_id);


--
-- Name: index_user_group_roles_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_user_group_roles_on_name ON user_group_roles USING btree (name);


--
-- Name: index_user_group_roles_user_roles_on_user_group_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_group_roles_user_roles_on_user_group_role_id ON user_group_roles_user_roles USING btree (user_group_role_id);


--
-- Name: index_user_group_roles_user_roles_on_user_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_group_roles_user_roles_on_user_role_id ON user_group_roles_user_roles USING btree (user_role_id);


--
-- Name: index_user_roles_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_user_roles_on_name ON user_roles USING btree (name);


--
-- Name: index_users_on_person_authenticated_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_person_authenticated_key ON users USING btree (person_authenticated_key);


--
-- Name: index_users_on_remember_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_remember_token ON users USING btree (remember_token);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_2e964899e5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_group_roles_user_roles
    ADD CONSTRAINT fk_rails_2e964899e5 FOREIGN KEY (user_role_id) REFERENCES user_roles(id);


--
-- Name: fk_rails_4fe83e9a4a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY join_entries
    ADD CONSTRAINT fk_rails_4fe83e9a4a FOREIGN KEY (content_profile_id) REFERENCES content_profiles(id);


--
-- Name: fk_rails_5a5f41d81f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY join_topics
    ADD CONSTRAINT fk_rails_5a5f41d81f FOREIGN KEY (content_profile_entry_id) REFERENCES content_profile_entries(id);


--
-- Name: fk_rails_5ddd6208a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY content_profiles
    ADD CONSTRAINT fk_rails_5ddd6208a6 FOREIGN KEY (profile_type_id) REFERENCES profile_types(id);


--
-- Name: fk_rails_7207991aa8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY join_contents
    ADD CONSTRAINT fk_rails_7207991aa8 FOREIGN KEY (content_profile_entry_id) REFERENCES content_profile_entries(id);


--
-- Name: fk_rails_846806fa23; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_group_roles_user_roles
    ADD CONSTRAINT fk_rails_846806fa23 FOREIGN KEY (user_group_role_id) REFERENCES user_group_roles(id);


--
-- Name: fk_rails_94efe6d586; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY topic_options
    ADD CONSTRAINT fk_rails_94efe6d586 FOREIGN KEY (topic_type_opt_id) REFERENCES topic_type_opts(id);


--
-- Name: fk_rails_ae3fa92629; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY topic_options
    ADD CONSTRAINT fk_rails_ae3fa92629 FOREIGN KEY (topic_type_id) REFERENCES topic_types(id);


--
-- Name: fk_rails_bc28dd584c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY content_options
    ADD CONSTRAINT fk_rails_bc28dd584c FOREIGN KEY (content_type_opt_id) REFERENCES content_type_opts(id);


--
-- Name: fk_rails_ca0493a174; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY join_contents
    ADD CONSTRAINT fk_rails_ca0493a174 FOREIGN KEY (content_type_id) REFERENCES content_types(id);


--
-- Name: fk_rails_dd6a020dd5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY join_entries
    ADD CONSTRAINT fk_rails_dd6a020dd5 FOREIGN KEY (content_profile_entry_id) REFERENCES content_profile_entries(id);


--
-- Name: fk_rails_ddec8e0316; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY join_topics
    ADD CONSTRAINT fk_rails_ddec8e0316 FOREIGN KEY (topic_type_id) REFERENCES topic_types(id);


--
-- Name: fk_rails_e7238fdd67; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY content_options
    ADD CONSTRAINT fk_rails_e7238fdd67 FOREIGN KEY (content_type_id) REFERENCES content_types(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20160113200706');


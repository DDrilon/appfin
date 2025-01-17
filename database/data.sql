PGDMP                      |           Drilon    16.3    16.3 -               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    16429    Drilon    DATABASE     �   CREATE DATABASE "Drilon" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'French_Switzerland.1252';
    DROP DATABASE "Drilon";
                postgres    false            �            1259    16438    application    TABLE     �   CREATE TABLE public.application (
    id_application integer NOT NULL,
    nom_application character varying(255) NOT NULL,
    description_application text,
    version_application character varying(50)
);
    DROP TABLE public.application;
       public         heap    postgres    false            �            1259    16437    application_id_application_seq    SEQUENCE     �   CREATE SEQUENCE public.application_id_application_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.application_id_application_seq;
       public          postgres    false    218                       0    0    application_id_application_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.application_id_application_seq OWNED BY public.application.id_application;
          public          postgres    false    217            �            1259    16447    asso_utilisateur_application    TABLE     �   CREATE TABLE public.asso_utilisateur_application (
    id_asso_utilisateur_application integer NOT NULL,
    id_utilisateur integer NOT NULL,
    id_application integer NOT NULL
);
 0   DROP TABLE public.asso_utilisateur_application;
       public         heap    postgres    false            �            1259    16446 ?   asso_utilisateur_application_id_asso_utilisateur_applicatio_seq    SEQUENCE     �   CREATE SEQUENCE public.asso_utilisateur_application_id_asso_utilisateur_applicatio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 V   DROP SEQUENCE public.asso_utilisateur_application_id_asso_utilisateur_applicatio_seq;
       public          postgres    false    220                       0    0 ?   asso_utilisateur_application_id_asso_utilisateur_applicatio_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.asso_utilisateur_application_id_asso_utilisateur_applicatio_seq OWNED BY public.asso_utilisateur_application.id_asso_utilisateur_application;
          public          postgres    false    219            �            1259    16464    messages    TABLE     �   CREATE TABLE public.messages (
    id_messages integer NOT NULL,
    id_utilisateur integer NOT NULL,
    id_application integer NOT NULL,
    text_messages text NOT NULL,
    date_messages date NOT NULL
);
    DROP TABLE public.messages;
       public         heap    postgres    false            �            1259    16463    messages_id_messages_seq    SEQUENCE     �   CREATE SEQUENCE public.messages_id_messages_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.messages_id_messages_seq;
       public          postgres    false    222                       0    0    messages_id_messages_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.messages_id_messages_seq OWNED BY public.messages.id_messages;
          public          postgres    false    221            �            1259    16483    response    TABLE     �   CREATE TABLE public.response (
    id_reponse integer NOT NULL,
    id_utilisateur integer NOT NULL,
    id_messages integer NOT NULL,
    text_reponse text NOT NULL,
    date_reponse date NOT NULL
);
    DROP TABLE public.response;
       public         heap    postgres    false            �            1259    16482    response_id_reponse_seq    SEQUENCE     �   CREATE SEQUENCE public.response_id_reponse_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.response_id_reponse_seq;
       public          postgres    false    224                       0    0    response_id_reponse_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.response_id_reponse_seq OWNED BY public.response.id_reponse;
          public          postgres    false    223            �            1259    16431    utilisateur    TABLE     �   CREATE TABLE public.utilisateur (
    id_utilisateur integer NOT NULL,
    username_utilisateur character varying(255) NOT NULL,
    date_enregistrement_utilisateur date NOT NULL
);
    DROP TABLE public.utilisateur;
       public         heap    postgres    false            �            1259    16430    utilisateur_id_utilisateur_seq    SEQUENCE     �   CREATE SEQUENCE public.utilisateur_id_utilisateur_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.utilisateur_id_utilisateur_seq;
       public          postgres    false    216                       0    0    utilisateur_id_utilisateur_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.utilisateur_id_utilisateur_seq OWNED BY public.utilisateur.id_utilisateur;
          public          postgres    false    215            e           2604    16441    application id_application    DEFAULT     �   ALTER TABLE ONLY public.application ALTER COLUMN id_application SET DEFAULT nextval('public.application_id_application_seq'::regclass);
 I   ALTER TABLE public.application ALTER COLUMN id_application DROP DEFAULT;
       public          postgres    false    218    217    218            f           2604    16450 <   asso_utilisateur_application id_asso_utilisateur_application    DEFAULT     �   ALTER TABLE ONLY public.asso_utilisateur_application ALTER COLUMN id_asso_utilisateur_application SET DEFAULT nextval('public.asso_utilisateur_application_id_asso_utilisateur_applicatio_seq'::regclass);
 k   ALTER TABLE public.asso_utilisateur_application ALTER COLUMN id_asso_utilisateur_application DROP DEFAULT;
       public          postgres    false    220    219    220            g           2604    16467    messages id_messages    DEFAULT     |   ALTER TABLE ONLY public.messages ALTER COLUMN id_messages SET DEFAULT nextval('public.messages_id_messages_seq'::regclass);
 C   ALTER TABLE public.messages ALTER COLUMN id_messages DROP DEFAULT;
       public          postgres    false    221    222    222            h           2604    16486    response id_reponse    DEFAULT     z   ALTER TABLE ONLY public.response ALTER COLUMN id_reponse SET DEFAULT nextval('public.response_id_reponse_seq'::regclass);
 B   ALTER TABLE public.response ALTER COLUMN id_reponse DROP DEFAULT;
       public          postgres    false    223    224    224            d           2604    16434    utilisateur id_utilisateur    DEFAULT     �   ALTER TABLE ONLY public.utilisateur ALTER COLUMN id_utilisateur SET DEFAULT nextval('public.utilisateur_id_utilisateur_seq'::regclass);
 I   ALTER TABLE public.utilisateur ALTER COLUMN id_utilisateur DROP DEFAULT;
       public          postgres    false    216    215    216                      0    16438    application 
   TABLE DATA           t   COPY public.application (id_application, nom_application, description_application, version_application) FROM stdin;
    public          postgres    false    218   {:                 0    16447    asso_utilisateur_application 
   TABLE DATA           w   COPY public.asso_utilisateur_application (id_asso_utilisateur_application, id_utilisateur, id_application) FROM stdin;
    public          postgres    false    220   n;                 0    16464    messages 
   TABLE DATA           m   COPY public.messages (id_messages, id_utilisateur, id_application, text_messages, date_messages) FROM stdin;
    public          postgres    false    222   �;                 0    16483    response 
   TABLE DATA           g   COPY public.response (id_reponse, id_utilisateur, id_messages, text_reponse, date_reponse) FROM stdin;
    public          postgres    false    224   E=       	          0    16431    utilisateur 
   TABLE DATA           l   COPY public.utilisateur (id_utilisateur, username_utilisateur, date_enregistrement_utilisateur) FROM stdin;
    public          postgres    false    216   �>                  0    0    application_id_application_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.application_id_application_seq', 5, true);
          public          postgres    false    217                       0    0 ?   asso_utilisateur_application_id_asso_utilisateur_applicatio_seq    SEQUENCE SET     n   SELECT pg_catalog.setval('public.asso_utilisateur_application_id_asso_utilisateur_applicatio_seq', 28, true);
          public          postgres    false    219                       0    0    messages_id_messages_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.messages_id_messages_seq', 8, true);
          public          postgres    false    221                        0    0    response_id_reponse_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.response_id_reponse_seq', 6, true);
          public          postgres    false    223            !           0    0    utilisateur_id_utilisateur_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.utilisateur_id_utilisateur_seq', 16, true);
          public          postgres    false    215            l           2606    16445    application application_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.application
    ADD CONSTRAINT application_pkey PRIMARY KEY (id_application);
 F   ALTER TABLE ONLY public.application DROP CONSTRAINT application_pkey;
       public            postgres    false    218            n           2606    16452 >   asso_utilisateur_application asso_utilisateur_application_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.asso_utilisateur_application
    ADD CONSTRAINT asso_utilisateur_application_pkey PRIMARY KEY (id_asso_utilisateur_application);
 h   ALTER TABLE ONLY public.asso_utilisateur_application DROP CONSTRAINT asso_utilisateur_application_pkey;
       public            postgres    false    220            p           2606    16471    messages messages_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id_messages);
 @   ALTER TABLE ONLY public.messages DROP CONSTRAINT messages_pkey;
       public            postgres    false    222            r           2606    16490    response response_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.response
    ADD CONSTRAINT response_pkey PRIMARY KEY (id_reponse);
 @   ALTER TABLE ONLY public.response DROP CONSTRAINT response_pkey;
       public            postgres    false    224            j           2606    16436    utilisateur utilisateur_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.utilisateur
    ADD CONSTRAINT utilisateur_pkey PRIMARY KEY (id_utilisateur);
 F   ALTER TABLE ONLY public.utilisateur DROP CONSTRAINT utilisateur_pkey;
       public            postgres    false    216            s           2606    16458 M   asso_utilisateur_application asso_utilisateur_application_id_application_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.asso_utilisateur_application
    ADD CONSTRAINT asso_utilisateur_application_id_application_fkey FOREIGN KEY (id_application) REFERENCES public.application(id_application);
 w   ALTER TABLE ONLY public.asso_utilisateur_application DROP CONSTRAINT asso_utilisateur_application_id_application_fkey;
       public          postgres    false    220    4716    218            t           2606    16453 M   asso_utilisateur_application asso_utilisateur_application_id_utilisateur_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.asso_utilisateur_application
    ADD CONSTRAINT asso_utilisateur_application_id_utilisateur_fkey FOREIGN KEY (id_utilisateur) REFERENCES public.utilisateur(id_utilisateur);
 w   ALTER TABLE ONLY public.asso_utilisateur_application DROP CONSTRAINT asso_utilisateur_application_id_utilisateur_fkey;
       public          postgres    false    4714    220    216            u           2606    16477 %   messages messages_id_application_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_id_application_fkey FOREIGN KEY (id_application) REFERENCES public.application(id_application);
 O   ALTER TABLE ONLY public.messages DROP CONSTRAINT messages_id_application_fkey;
       public          postgres    false    218    222    4716            v           2606    16472 %   messages messages_id_utilisateur_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_id_utilisateur_fkey FOREIGN KEY (id_utilisateur) REFERENCES public.utilisateur(id_utilisateur);
 O   ALTER TABLE ONLY public.messages DROP CONSTRAINT messages_id_utilisateur_fkey;
       public          postgres    false    216    222    4714            w           2606    16496 "   response response_id_messages_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.response
    ADD CONSTRAINT response_id_messages_fkey FOREIGN KEY (id_messages) REFERENCES public.messages(id_messages);
 L   ALTER TABLE ONLY public.response DROP CONSTRAINT response_id_messages_fkey;
       public          postgres    false    224    222    4720            x           2606    16491 %   response response_id_utilisateur_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.response
    ADD CONSTRAINT response_id_utilisateur_fkey FOREIGN KEY (id_utilisateur) REFERENCES public.utilisateur(id_utilisateur);
 O   ALTER TABLE ONLY public.response DROP CONSTRAINT response_id_utilisateur_fkey;
       public          postgres    false    224    216    4714               �   x�]O;n�0��S�Bc'@�vh�b KVa%�$�������Je��A�{x�8���V�7���J�G����R<�}�u���$w��@\��3��ᕤ�3&�V��O��x��*�+�@v�����D�x��~Js2�x�jІ��Z��_È^0�����^�l��W����X�+���l�`:����x&�1g+ij���-�u�}%��Fۻ������p�         h   x���� �V1�H/鿎H�,��0D*�V6&*;Zӣ,�����0��K���t�)�AW�5��:��YH�m{�r���3�\}�~L�]��= ~��x         O  x���MN�0���)�UWA�m�g�z6�3S9v�O%n�X5�����		ya���ͼW���N���I�'k�C�����0�S�'묶=�E~E��r�]�5>����X�e�U���!�H'ZXR>2���n>3��4�񆩊�fH+�09���i�a%AR7O0 Ol�ȣ�=ʨl�[I��/\�5���١34�B�%��F�.�^�7C�l���5F�W�&/ʬ�������5�0�׋�A�	h��:z8HE����G��+�l-ʚ�|FN��Sژ���@�LB���J�7y�M�oD�pf&F���lE�f�?7V��Ҥ�����,˾ �k�         ,  x�m�=n�0�g���%,'v�u�֥(б�*3�YR��js_�T�6K����=>	�2��b��J*�°UaL`$L�����F+���0-״\|d���r�F��;�6��n�Z��e{�n�9H���Tk3Br9����!�����Il�[�%,��l߳AO�&��c)�X��^2�<;��Q+�&�Rpy��z���b�����H�9�W�ޖ)"�&�p�
���2+��J������v?�M�;ʵc�.I���uwk ��2���J'�!x���SZu�P����8�?��      	   �   x�U��� ���`إ?Ƅ %)!�_m� �7���mխ-k6J�"���ɍg>6qV�р/9&����F��B.����-������ǇDV�EҰ�\����o�_"A��EyR#j&]�H�Ȟ4O^O{����~A��TC�     
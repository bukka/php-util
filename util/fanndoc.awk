BEGIN {
	add_count = -1;
	add_msg = "";
	add_del = 0;
	del = 0;
	add_see_also = 0;
	add_on_error = 0;
}
{
	if (add_count == 0) {
		print add_msg;
		del = add_del;
		add_del = 0;
	}
	add_count--;
	if (del <= 0) {
		if ($1 == "<methodparam><type>string</type><parameter>ann</parameter></methodparam>")
			print "   <methodparam><type>resource</type><parameter>ann</parameter></methodparam>";
		else if ($1 == "<methodparam><type>string</type><parameter>data</parameter></methodparam>")
			print "   <methodparam><type>resource</type><parameter>data</parameter></methodparam>";
		else if ($1 == "<methodparam><type>string</type><parameter>train_data</parameter></methodparam>")
			print "   <methodparam><type>resource</type><parameter>train_data</parameter></methodparam>";
		else if ($1 == "<refpurpose>Description</refpurpose>")
			print "  <refpurpose></refpurpose>"
		else
			print $0;
		
		if ($1 == "<term><parameter>ann</parameter></term>") {
			add_count = 1;
			add_msg = "     &fann.ann.description;";
			add_del = 3;
		}
		else if ($1 == "<term><parameter>train_data</parameter></term>" || $1 == "<term><parameter>data</parameter></term>") {
			add_count = 1;
			add_msg = "     &fann.train.description;";
			add_del = 3;
		}
		else if ($2 == "role=\"returnvalues\">") {
			add_count = 1;
			add_msg = "  &fann.return.bool;";
			add_see_also = 1;
			add_on_error = 1;
		}
		else if (add_on_error && $1 == "<para>") {
			print "    , or &false; on error.";
			del = 1;
			add_on_error = 0;
		}
		else if (add_see_also && $1 == "</refsect1>") {
			print "";
			print " <refsect1 role=\"seealso\">";
			print "  &reftitle.seealso;";
			print "  <para>";
			print "   <simplelist>";
			print "    <member><function></function></member>";
			print "   </simplelist>";
			print "  </para>"
			print " </refsect1>";
			add_see_also = 0;
		}		
	}
	else
		del--;
}
